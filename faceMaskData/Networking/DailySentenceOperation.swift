import Kanna
import CoreData
import UIKit

class DailySentenceOperation: Operation, URLSessionTaskDelegate, URLSessionDelegate, URLSessionDataDelegate {
    
    var task: URLSessionTask?
    private let incomingData = NSMutableData()
    
    var internalFinished: Bool = false
    override var isFinished: Bool {
        get {
            return internalFinished
        }
        set (newAnswer) {
            willChangeValue(forKey: "isFinished")
            internalFinished = newAnswer
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override init() {
        super.init()
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
        if let url = URL(string: urlStringType.DailySentence.today()) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: url)
            print(urlStringType.DailySentence.today())
            task.resume()
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        if isCancelled {
            print("http code error")
        }
        
        // fine keep going
        completionHandler(.allow)
    }
    
    //This method gets called zero or more times, untill request is done, here is where we get incoming data
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        if isCancelled {
            isFinished = true
            dataTask.cancel()
            return
        }
        incomingData.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if isCancelled {
            isFinished = true
            task.cancel()
            return
        }
        if error != nil {
            print(error)
            isFinished = true
        }
        
        let today = todayString()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DailySentence")
        let entity = NSEntityDescription.entity(forEntityName: "DailySentence", in: context)
        
        //檢查今天是否已有每日一句
        request.predicate = NSPredicate(format: "date = %@", today)
        var dataExsited: Bool? { return try? context.count(for: request) == 0 ? false : true }
        guard dataExsited == false else { return }
        
        var sentence:String?
        var author:String?
        
        //抓取每日一句並傳給 sentence 和 author 變數
        dailySentenceScraping()
        
        //sentence 和 author 變數存入CoreData
        insertDataIntoLocal()
        
        // 結束
        isFinished = true
        
        func dailySentenceScraping() {
            do {
                let contents = String(data: incomingData as Data, encoding: .utf8)!
                let parsedHTML = try Kanna.HTML(html: contents, encoding: String.Encoding.utf8)
                
                sentence = parsedHTML.xpath("/html/body/div[1]/article/div/div/div[2]/p[2]")
                    .first?
                    .text?
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                
                author = parsedHTML.xpath("/html/body/div[1]/article/div/div/div[2]/h1")
                    .first?
                    .text?
                    .trimmingCharacters(in: .whitespacesAndNewlines)
            }
            catch { print("error") }
        }
        
        func insertDataIntoLocal() {
                
            do {
                let newSentence = NSManagedObject(entity: entity!, insertInto: context)
                newSentence.setValue("\(author ?? "")", forKey: "author")
                newSentence.setValue("\(sentence ?? "")", forKey: "sentence")
                newSentence.setValue(today, forKey: "date")
                try context.save()
            }
            catch {
                print("sentence error")
            }
        }
    }
}


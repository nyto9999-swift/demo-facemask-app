import Kanna
import CoreData
import UIKit

class DailySentenceOperation: Operation, URLSessionTaskDelegate, URLSessionDelegate, URLSessionDataDelegate {
    var task: URLSessionTask?
    let incomingData = NSMutableData()
    var local = CoreDataController.shared
    
    
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
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        if let url = URL(string: urlStringType.DailySentence.today()) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: url)
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
            print("sentence didcompletewitherror")
            isFinished = true
        }
        var sentence:String?
        var author:String?
        
        //??????????????????????????? sentence ??? author ??????
        
        
       
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
        
        
        //sentence ??? author ????????????CoreData
        local.updateDailySentence(author: author, sentence: sentence)
        
        // ??????
        isFinished = true
    }
}


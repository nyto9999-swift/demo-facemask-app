import CoreData
import UIKit


protocol NetworkDelegate
{
    func networkResponse()
}

class FaceMaskOperation: Operation, URLSessionTaskDelegate, URLSessionDelegate, URLSessionDataDelegate {
    
    var data: [faceMaskDataFaceMasks]?
    var local = CoreDataController.shared
    var delegate: NetworkDelegate?
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
            //delegate
            delegate?.networkResponse()
        }
    }
    
    override init() {
        super.init()
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        if let url = URL(string: urlStringType.FaceMask.rawValue) {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request)
            task.resume()
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        if isCancelled {
            print("http code error")
        }
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
            print("faceMask didCompletedWithError")
            isFinished = true
        }
        
        //檢查CoreData是否已有資料
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FaceMasks")
        var dataExsited: Bool? { return try? context.count(for: request) == 0 ? false : true }
        guard dataExsited == false else { isFinished = true; return }
           
        var taichungData = [FaceMask]()
        
        do {
            let decodedData = try JSONDecoder().decode(FaceMakeData.self, from: incomingData as Data)
            guard let data = decodedData.features else { isFinished = true; return }
            let filteredData = data.filter { $0.faceMask.county == "臺中市" }
            taichungData = filteredData
        } catch { print(error) }
        
        local.insertFaceMasks(taichungData: taichungData)
        
        //結束
        isFinished = true
    }
}

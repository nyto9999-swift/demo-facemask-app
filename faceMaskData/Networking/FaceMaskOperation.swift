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
    let incomingData = NSMutableData()
    var taichungData = [FaceMask]()
    
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
        
        //??????CoreData??????????????????
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FaceMasks")
        
        var dataExsited: Bool? { return try? context.count(for: request) == 0 ? false : true }
        guard dataExsited == false else { isFinished = true; return }
        
        do {
            let decodedData = try JSONDecoder().decode(FaceMakeData.self, from: incomingData as Data)
            guard let data = decodedData.features else { isFinished = true; return }
            let filteredData = data.filter { $0.faceMask.county == "?????????" }
            
            taichungData = filteredData
        } catch { print(error) }
        
        func loadFaskMaskJson () {
            
        }
        
        
        local.insertFaceMasks(taichungData: taichungData)
        
        //??????
        isFinished = true
    }
}

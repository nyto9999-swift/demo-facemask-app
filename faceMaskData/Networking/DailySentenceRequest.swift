//
//  FaceMaskOperation.swift
//  faceMaskData
//
//  Created by 宇宣 Chen on 2022/5/14.
//
import Kanna
import UIKit

class DailySentenceRequest: Operation, URLSessionTaskDelegate, URLSessionDelegate, URLSessionDataDelegate {
    
    var task: URLSessionTask?
    private let incomingData = NSMutableData()
    
    var internalFinished: Bool = false
    override var isFinished: Bool {
        get {
            print("\\dailySentenceReceiveOldData\\")
            return internalFinished
        }
        set (newAnswer) {
            print("\\dailySentenceReceiveNewData\\")
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
        
        print("Now, you can start scrapping")
        let contents = String(data: incomingData as Data, encoding: .utf8)!
        
        do {
            let parsedHTML = try Kanna.HTML(html: contents, encoding: String.Encoding.utf8)
            let sentence = parsedHTML.xpath("/html/body/div[1]/article/div/div/div[2]/p[2]")
//            print(sentence.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines))
            let author = parsedHTML.xpath("/html/body/div[1]/article/div/div/div[2]/h1")
//            print(author.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines))
            
        }
        catch {
            print("error")
        }
        
        isFinished = true
    }
    
    
    
    
}


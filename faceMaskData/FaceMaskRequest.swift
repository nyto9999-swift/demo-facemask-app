//
//  FaceMaskOperation.swift
//  faceMaskData
//
//  Created by 宇宣 Chen on 2022/5/14.
//
import CoreData
import UIKit

class FaceMaskRequest: Operation, URLSessionTaskDelegate, URLSessionDelegate, URLSessionDataDelegate {
    
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
        if let url = URL(string: URLString.FaceMask.rawValue) {
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
        
        // fine keep going
        completionHandler(.allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        //This method gets called zero or more times, untill request is done, here is where we get incoming data
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
            print("hi3")
            task.cancel()
            return
        }
        if error != nil {
            print(error)
            isFinished = true
        }
        
        print("Now, you can insert incoming data into coredata")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let decodedData = try JSONDecoder().decode(FaceMakeData.self,
                                                       from: incomingData as Data)
            if let features = decodedData.features {
                for feature in features {
                    
                    let taichung = feature.properties
                    let adult = taichung.mask_adult ?? 0
                    let child = taichung.mask_child ?? 0
                    let totalMasks = adult + child
                    let town = taichung.town
                    let entity = NSEntityDescription.entity(forEntityName: "FaceMasks", in: context)
                    let newFaceMask = NSManagedObject(entity: entity!, insertInto: context)
                    //MARK: if 該地區已經在local 把口罩數量加到該地區, else insert newFaceMask
                    
                    //        let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
                    //        let newUser = NSManagedObject(entity: entity!, insertInto: context)
                    //        newUser.setValue("Tony", forKey: "username")
                    //        do {
                    //            try context.save()
                    //        }
                    //        catch let err {
                    //            print(err)
                    //        }
                    
                    //        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
                    //        request.predicate = NSPredicate(format: "username = %@", "Tony")
                    //        request.returnsObjectsAsFaults = false
                    //        do {
                    //            let result = try context.fetch(request)
                    //            for data in result as! [NSManagedObject] {
                    //                print(data.value(forKey: "username") as! String)
                    //            }
                    //        }
                    //        catch let err {
                    //            print(err)
                    //        }
                }
            }
        } catch {
            print(error)
        }
        
        isFinished = true
        
    }
    
    
    
    
}


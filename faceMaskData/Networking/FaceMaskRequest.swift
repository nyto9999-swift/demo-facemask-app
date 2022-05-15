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
            print("hi3")
            task.cancel()
            return
        }
        if error != nil {
            print(error)
            isFinished = true
        }
        
        print("Now, you can insert incoming data into coredata")
        
        var taichungData = [Feature]()
        //MARK: JsonDecoder
        do {
            let decodedData = try JSONDecoder().decode(FaceMakeData.self,
                                                       from: incomingData as Data)
            guard let data = decodedData.features else { return }
            let filteredData = data.filter { $0.properties.county == "臺中市" }
            taichungData = filteredData
        } catch { print(error) }
        
        //MARK: CoreData
        var context: NSManagedObjectContext {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.persistentContainer.viewContext
        }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FaceMasks")
        let entity = NSEntityDescription.entity(forEntityName: "FaceMasks", in: context)
        
        
        //first time
        var count: Int? {
            return try? context.count(for: request)
        }
        if count != 0 { return }
        
        //MARK: 把Json資料放到Local
        for data in taichungData {
            
            let childMasks = data.properties.mask_child ?? 0
            let adultMasks = data.properties.mask_adult ?? 0
            let totalMasks = childMasks + adultMasks
            let town       = data.properties.town
            guard let town = town else { return }
            
            //確認地區是否已經存在於local
            let request = NSFetchRequest<faceMaskDataFaceMasks>(entityName: "FaceMasks")
            let predicate = NSPredicate(format: "town = %@", "\(town)")
            request.predicate = predicate
            request.fetchLimit = 1
            
            //存進local
            do {
                let localMaskData = try context.fetch(request)
                let theLocalMaskData = localMaskData.first
                
                // 新資料
                if theLocalMaskData == nil {
                    
                    let newFaceMask = NSManagedObject(entity: entity!, insertInto: context)
                    newFaceMask.setValue("\(town)", forKey: "town")
                    newFaceMask.setValue(Int32(totalMasks), forKey: "quantity")
                    
                }
                // 已有資料，累加口罩
                else {
                    theLocalMaskData?.quantity += Int32(totalMasks)
                }
                
                try context.save()
            }
            catch {
                print("errrrror")
            }
        }
        
        isFinished = true
    }
    
    
    
    
}


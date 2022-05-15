//
//  NetworkController.swift
//  faceMaskData
//
//  Created by 宇宣 Chen on 2022/5/14.
//

import Foundation
import UIKit
import CoreData
 
class NetworkController: NSObject {
    let queue = OperationQueue()
    
    let faceMask = FaceMaskRequest()
    override init(){
        queue.addOperation(faceMask)
//        deleteAllData()
    }
    
    
    var context: NSManagedObjectContext {
       let appDelegate = UIApplication.shared.delegate as! AppDelegate
       return appDelegate.persistentContainer.viewContext
    }
    
    func deleteAllData() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FaceMasks")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
            
        } catch let error {
            print("Detele all data in \("facemask") error :", error)
        }
        
        do {
            try context.save()
        }
        catch {
            print("hi")
        }
    }
    
}

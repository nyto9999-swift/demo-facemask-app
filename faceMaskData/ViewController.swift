//
//  ViewController.swift
//  faceMaskData
//
//  Created by 宇宣 Chen on 2022/5/13.
//

import UIKit
import CoreData



class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        FaceMaskRequest()
//        deleteAllData()
        
        print("CoreData path: \(localPath)")
        view.backgroundColor = .red
        
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

 

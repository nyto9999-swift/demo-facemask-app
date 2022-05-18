import Foundation
import UIKit
import CoreData

enum urlStringType: String {
    case FaceMask = "https://raw.githubusercontent.com/kiang/pharmacies/master/json/points.json"
    case DailySentence = "https://tw.feature.appledaily.com/collection/dailyquote/"
    
    
    func today() -> String {
        //20210520
        return urlStringType.DailySentence.rawValue + todayString()
    }
}

func todayString() -> String {
    let date = Date()
    let todayString = date.getFormattedDate(format: "yyyyMMdd")
    
    return todayString
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}


//MARK: CoreData
let localPath = NSPersistentContainer.defaultDirectoryURL()

var context: NSManagedObjectContext {
   let appDelegate = UIApplication.shared.delegate as! AppDelegate
   return appDelegate.persistentContainer.viewContext
}


func deleteAllMasks() {
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

func deleteAllSentence() {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DailySentence")
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

 
public extension UIView {
    func pin(to superView: UIView) {
           translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.topAnchor).isActive = true
           leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
           trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
           bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
   }
}

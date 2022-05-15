 import Foundation
import UIKit
import CoreData



enum urlStringType: String {
    case FaceMask = "https://raw.githubusercontent.com/kiang/pharmacies/master/json/points.json"
    case DailySentence = "https://tw.feature.appledaily.com/collection/dailyquote/" //fix later
    
    
    func today() -> String {
        //20210520
        let date = Date()
        let format = date.getFormattedDate(format: "yyyyMMdd")
        
        return urlStringType.DailySentence.rawValue + "\(format)"
    }
}

extension Date {
   func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}

 
let localPath = NSPersistentContainer.defaultDirectoryURL()


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

 

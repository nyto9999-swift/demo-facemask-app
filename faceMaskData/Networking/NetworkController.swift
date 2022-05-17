import Foundation
import UIKit
import CoreData
 
class NetworkController: NSObject {
    
    static let shared = NetworkController()
    
    override init() {
        let queue = OperationQueue()
        queue.addOperation(FaceMaskOperation())
        queue.addOperation(DailySentenceOperation())
        
    }
    
    func localFaceMaskData() -> [faceMaskDataFaceMasks]? {
        
        var data = [faceMaskDataFaceMasks]()
        let request = NSFetchRequest<faceMaskDataFaceMasks>(entityName: "FaceMasks")
        
        print("localFaceMaskData")
            return try? context.fetch(request)
    }
    
        func localDailySentenceData() -> [faceMaskDataDailySentence] {
            var data = [faceMaskDataDailySentence]()
            let request = NSFetchRequest<faceMaskDataDailySentence>(entityName: "DailySentence")
            do {
                let sentenceData = try context.fetch(request)
                data = sentenceData
            }
            catch {
                print("error")
            }
            return data
        }
    
        func localTownData(localFaceMaskData: [faceMaskDataFaceMasks] ) -> [String] {
    
            var towns = [String]()
    
            for data in localFaceMaskData {
    
                if data.town != "" {
                    towns.append(data.town!)
                }
            }
    
            return towns
        }
    
}



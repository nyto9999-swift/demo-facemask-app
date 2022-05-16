import Foundation
import UIKit
import CoreData
 
class NetworkController: NSObject {
    let queue = OperationQueue()
    
    override init(){
        super.init()
        queue.addOperation(FaceMaskOperation())
        queue.addOperation(DailySentenceOperation())
    }
    
    func localFaceMaskData() -> [faceMaskDataFaceMasks]? {
        let request = NSFetchRequest<faceMaskDataFaceMasks>(entityName: "FaceMasks")
        return try? context.fetch(request)
    }
    
    func localDailySentenceData() -> [faceMaskDataDailySentence]? {
        let request = NSFetchRequest<faceMaskDataDailySentence>(entityName: "DailySentence")
        return try? context.fetch(request)
    }
    
    func regionFilter(){}
}

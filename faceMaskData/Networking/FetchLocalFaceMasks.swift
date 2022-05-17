import Kanna
import CoreData
import UIKit

class FetchLocalFaceMasks: Operation {
    
    var task: URLSessionTask?
    private let incomingData = NSMutableData()
    var internalFinished: Bool = false
    var finishe: Bool {
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
        let request = NSFetchRequest<faceMaskDataFaceMasks>(entityName: "FaceMasks")
        print("facemaskdata")
        do {
            try context.fetch(request)
            self.finishe = true
        }
        catch {
            print("hi")
        }
    }
    
    
    
   
}


import Foundation
import UIKit
import CoreData

class NetworkController: UIViewController {
    
    let queue = OperationQueue()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        queue.addOperation(FaceMaskOperation())
        queue.addOperation(DailySentenceOperation())
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        view.backgroundColor = .blue
    }
    
    
    func localDailySentenceData() -> [faceMaskDataDailySentence] {
        var data = [faceMaskDataDailySentence]()
        let request = NSFetchRequest<faceMaskDataDailySentence>(entityName: "DailySentence")
        do {
            let sentenceData = try context.fetch(request)
            data = sentenceData
            print("Iam local sentence")
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



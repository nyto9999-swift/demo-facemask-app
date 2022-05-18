import CoreData
import UIKit
import Foundation

class CoreDataController {
    
    static let shared = CoreDataController()
    
    public func fetchFaceMasks(showAll: Bool) -> [faceMaskDataFaceMasks]?  {
        let request = NSFetchRequest<faceMaskDataFaceMasks>(entityName: "FaceMasks")
        
        if showAll {
            return try? context.fetch(request)
            
        }
        else {
            let predicate = NSPredicate(format: "userChoice == YES")
            request.predicate = predicate
            return try? context.fetch(request)
        }
        
    }
    
    func fetchDailySentences() -> [faceMaskDataDailySentence] {
        
        let request = NSFetchRequest<faceMaskDataDailySentence>(entityName: "DailySentence")
        do {
            return try context.fetch(request)
        }
        catch {
            print("request sentence error")
        }
        return []
    }
    
    func fileterdFaceMasks(byTown towns: [String], completion: @escaping (Result<[faceMaskDataFaceMasks], Error>) -> Void){
        
        var faskMask = [faceMaskDataFaceMasks]()
        
        for town in towns {
            print(town)
            let request = NSFetchRequest<faceMaskDataFaceMasks>(entityName: "FaceMasks")
            
            let predicate = NSPredicate(format: "town = %@", town)
            request.predicate = predicate
            request.fetchLimit = 1
            
            do {
                let localMasks = try context.fetch(request)
                let theLocalMask = localMasks.first
                
                if let theLocalMask = theLocalMask {
                    faskMask.append(theLocalMask)
                    print(theLocalMask.town)
                }
                
            }
            catch {
                print("filteredFaceMasks error")
                completion(.failure(error))
            }
        }
        completion(.success(faskMask))
    }
    
    
    
    func updateFaskMask(town: String) {
        let request = NSFetchRequest<faceMaskDataFaceMasks>(entityName: "FaceMasks")
        let predicate = NSPredicate(format: "town = %@", town)
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            let localMasks = try context.fetch(request)
            
            if let mask = localMasks.first {
                mask.userChoice = false
                try context.save()
            }
        }
        catch {
            print("error")
        }
    }
    
    
}

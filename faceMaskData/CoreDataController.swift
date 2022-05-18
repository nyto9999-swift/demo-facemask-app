import CoreData
import UIKit
import Foundation

class CoreDataController {
    static let shared = CoreDataController()
    
    //faceMask methods
    func insertFaceMasks(taichungData: [FaceMask]) {
        for data in taichungData {
        
            let childMasks = data.faceMask.mask_child ?? 0
            let adultMasks = data.faceMask.mask_adult ?? 0
            let totalMasks = childMasks + adultMasks
            let town       = data.faceMask.town
                        
            let entity = NSEntityDescription.entity(forEntityName: "FaceMasks", in: context)
            let request = NSFetchRequest<faceMaskDataFaceMasks>(entityName: "FaceMasks")
            let predicate = NSPredicate(format: "town = %@", "\(town ?? "無資料")")
            request.predicate = predicate
            request.fetchLimit = 1
            
            //存進local
            do {
                let localMasks = try context.fetch(request)
                let theLocalMask = localMasks.first
                
                // 新資料
                if theLocalMask == nil {
                    
                    let newFaceMask = NSManagedObject(entity: entity!, insertInto: context)
                    newFaceMask.setValue("\(town ?? "無資料")", forKey: "town")
                    newFaceMask.setValue(Int32(totalMasks), forKey: "quantity")
                    
                }
                // 已有資料，累加口罩
                else {
                    theLocalMask?.quantity += Int32(totalMasks)
                }
                
                try context.save()
            }
            catch {
                print("insertFaceMask fail")
            }
        }
    }
    
    func fetchFaceMasks(completion: @escaping (Result<[faceMaskDataFaceMasks]?, Error>) -> Void){
        var filteredCount = 0
        let request = NSFetchRequest<faceMaskDataFaceMasks>(entityName: "FaceMasks")
        let predicate = NSPredicate(format: "isFiltered == YES")
        request.predicate = predicate
        
        do {
            filteredCount = try context.count(for: request)
        }
        catch {
            completion(.failure(error))
        }
            
        if filteredCount == 0 {
            self.fetchAllFaceMasks { result in
                switch result {
                    case .success(let allMasks):
                        completion(.success(allMasks))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
        else {
            completion(.success(try? context.fetch(request)))
        }
    }
    
    func setIsFilteredMask(byTown towns: [String], completion: @escaping (Result<[faceMaskDataFaceMasks]?, Error>) -> Void){
        //近來的都是想看的
        
        for town in towns {
            let request = NSFetchRequest<faceMaskDataFaceMasks>(entityName: "FaceMasks")
            let predicate = NSPredicate(format: "town = %@", town)
            request.predicate = predicate
            request.fetchLimit = 1
            
            do {
                let localMasks = try context.fetch(request)
                let theLocalMask = localMasks.first
                theLocalMask?.isFiltered.toggle()
                try context.save()
            }
            catch {
                print("filteredFaceMasks error")
                completion(.failure(error))
            }
        }
        
        self.fetchFaceMasks { result in
            switch result {
                case .success(let masks):
                    completion(.success(masks))
                case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
    
    func deleteFaceMask(town: String) {
        
        let request = NSFetchRequest<faceMaskDataFaceMasks>(entityName: "FaceMasks")
        let predicate = NSPredicate(format: "town = %@", town)
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            let localMasks = try context.fetch(request)
            for object in localMasks {
                context.delete(object)
            }
        }
        catch {
            print("updateFaskMask fail")
        }
    }
    
    func fetchAllFaceMasks(completion: @escaping (Result<[faceMaskDataFaceMasks]?, Error>) -> Void){
        let request = NSFetchRequest<faceMaskDataFaceMasks>(entityName: "FaceMasks")
        completion(.success(try? context.fetch(request)))
    }
    
    
    //dailySentence methods
    func fetchDailySentences() -> [faceMaskDataDailySentence]? {
        let request = NSFetchRequest<faceMaskDataDailySentence>(entityName: "DailySentence")
        request.returnsObjectsAsFaults = false
        return try? context.fetch(request)
    }
    
    func updateDailySentence(author: String?, sentence: String?) {
        
        deleteAllSentence()
        
        let entity = NSEntityDescription.entity(forEntityName: "DailySentence", in: context)
        let newSentence = NSManagedObject(entity: entity!, insertInto: context)
        
        if let author = author,
           let sentence = sentence
        
        {
            newSentence.setValue(author, forKey: "author")
            newSentence.setValue(sentence, forKey: "sentence")
        }
     
        
        do {
            try context.save()
        }
        catch {
            print("create new data fail")
        }
    }
}

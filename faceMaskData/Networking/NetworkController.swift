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
    
    override init(){
        queue.addOperation(FaceMaskRequest())
        queue.addOperation(DailySentenceRequest())

    }
    func prepareFaceMaskData(){}
    func prepareDailySentenceData(){}
    

    
}

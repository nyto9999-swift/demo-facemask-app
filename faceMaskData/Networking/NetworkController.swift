import Foundation
import UIKit
import CoreData

class NetworkController: NSObject, NetworkDelegate {
    let queue = OperationQueue()
    
    func loadNetworkData() {
        let faceMaskOperation = FaceMaskOperation()
        let sentenceOperation = DailySentenceOperation()
        
        queue.addOperation(faceMaskOperation)
        queue.addOperation(sentenceOperation)
        faceMaskOperation.delegate = self
    }
    
    func networkResponse() {

        let vc = ViewController()
        vc.title = "台中地區口罩"
        UIApplication.shared.currentUIWindow()?.rootViewController = UINavigationController(rootViewController: vc)
    }
}







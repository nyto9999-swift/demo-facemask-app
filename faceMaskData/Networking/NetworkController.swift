import Foundation
import UIKit
import CoreData

class NetworkController: UIViewController, NetworkDelegate {
    let queue = OperationQueue()
    var faceMaskFinished = false
    
    func faceMaskResponse(done: Bool) {
        if done == true {
            
            let vc = ViewController()
            vc.title = "台中地區口罩"
            let nav = UINavigationController()
            nav.viewControllers = [vc]
            nav.modalPresentationStyle = .fullScreen
            nav.modalTransitionStyle = .crossDissolve
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        let faceMaskOperation = FaceMaskOperation()
        let sentenceOperation = DailySentenceOperation()
        queue.addOperation(faceMaskOperation)
        queue.addOperation(sentenceOperation)
        faceMaskOperation.addDependency(sentenceOperation)
        faceMaskOperation.delegate = self
    }
}







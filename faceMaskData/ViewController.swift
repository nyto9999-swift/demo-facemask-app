//
//  ViewController.swift
//  faceMaskData
//
//  Created by 宇宣 Chen on 2022/5/13.
//

import UIKit
import CoreData



class ViewController: UIViewController {
    
    var faceMasks:[faceMaskDataFaceMasks]?
    var sentences:[faceMaskDataDailySentence]?
    
    init(faceMaskData: [faceMaskDataFaceMasks]? , dailySentenceData: [faceMaskDataDailySentence]? ) {
        super.init(nibName: nil, bundle: nil)
        self.faceMasks = faceMaskData
        self.sentences = dailySentenceData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let faceMasks = faceMasks {
            for faceMask in faceMasks {
                print(faceMask.town)
            }
        }
        
        print("CoreData path: \(localPath)")
        view.backgroundColor = .white
        
        
        
    }

    
}

 

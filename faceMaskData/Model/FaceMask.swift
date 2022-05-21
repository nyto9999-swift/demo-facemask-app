//
//  FaceMask.swift
//  faceMaskData
//
//  Created by 宇宣 Chen on 2022/5/14.
//

import Foundation

struct FaceMakeData: Codable,Equatable {
    var type: String?
    var features: [FaceMask]?
    
}

struct FaceMask: Codable, Equatable {
    static func == (lhs: FaceMask, rhs: FaceMask) -> Bool {
        return true
    }
    
    var faceMask: Properties
    
    enum CodingKeys: String, CodingKey {
        case faceMask = "properties"
    }
}

struct Properties: Codable {
    var county: String?
    var town: String?
    var mask_adult: Int?
    var mask_child: Int?
}



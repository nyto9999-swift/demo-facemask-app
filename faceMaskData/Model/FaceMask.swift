//
//  FaceMask.swift
//  faceMaskData
//
//  Created by 宇宣 Chen on 2022/5/14.
//

import Foundation

struct FaceMakeData: Codable {
    var type: String?
    var features: [Feature]?
}

struct Feature: Codable {
    var properties: Properties
}

struct Properties: Codable {
    var county: String?
    var town: String?
    var mask_adult: Int?
    var mask_child: Int?
}



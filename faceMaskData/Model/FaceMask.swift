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
    var town: String?
    var mask_adult: Int?
    var mask_child: Int?
}

enum URLString: String {
    case FaceMask = "https://raw.githubusercontent.com/kiang/pharmacies/master/json/points.json"
    case DailySentence = "https://tw.feature.appledaily.com/collection/dailyquote" //fix later
}



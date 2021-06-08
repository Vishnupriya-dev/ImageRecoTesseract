//
//  ImageModel.swift
//  ImageExtractor
//
//  Created by Vishnu on 07/06/21.
//

import Foundation

struct wordAPIModel: Codable {
    var word: String?
    var synonyms: [Int: String]?
    var antonyms: [Int: String]?
}



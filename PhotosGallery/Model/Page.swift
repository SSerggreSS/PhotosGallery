//
//  Page.swift
//  PhotosGallery
//
//  Created by Сергей  Бей on 27.11.2020.
//

import Foundation

struct Page: Decodable {
    let total: Int
    let results: [Result]
}

struct Result: Decodable {
    let width: Int
    let height: Int
    let createdAt: String
    let urls: [PhotoResolution.RawValue: String]
    let likes: Int
    
    enum CodingKeys: String, CodingKey {
        case width
        case height
        case urls
        case createdAt = "created_at"
        case likes
    }
}

enum PhotoResolution: String {
    case raw
    case full
    case regular
    case small
    case thumb
}

//yGH4JnsAR4k3isP3sqfbdFypOg6lLUF9Lq93porQDmU



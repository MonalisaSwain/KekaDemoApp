//
//  ArticleModel.swift
//  KekaDemoApp
//
//  Created by Monalisa.Swain on 14/08/24.
//

import Foundation

//Description - abstract
//Title - headline -> main
//Date - pub_date
//image - multimedia - 0 - url


struct ArticleResponse: Decodable {
    let response: Docs
}

struct Docs: Decodable {
    let docs: [Article]
}

struct Article : Decodable {
    var title : Headline
    var description: String
    var date: String
    var image: [Multimedia]?
    
    enum CodingKeys: String, CodingKey {
        case title = "headline"
        case description = "abstract"
        case date = "pub_date"
        case image = "multimedia"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter.date(from: date) {
            formatter.dateFormat = "MMMM yyyy"
            return formatter.string(from: date)
        }
        return date
    }
}

struct Headline : Decodable {
    var main : String
}

struct Multimedia : Decodable {
    var url : String
    
}



//
//  Genre.swift
//  movieApp
//
//  Created by Lucas Di Lorenzo on 12/12/2021.
//

import Foundation

struct Genre: Codable {
    
    var id: Int?
    var name: String?
    
}

struct Genres: Codable {
    
    let genres:[Genre]
    
}

//
//  Show.swift
//  movieApp
//
//  Created by Lucas Di Lorenzo on 12/12/2021.
//

import Foundation


// Decodable es un tipo que puede transformar una representación externa en un objeto. Eso significa que puede interpretar un JSON y transformarlo en objetos de tipo decodable.

struct Show: Codable {
    
    let name: String?
    var genre_ids: [Int]?
    let poster_path: String?
    
    let backdrop_path:String?
    let overview:String?
    let first_air_date:String?
    
}

struct ShowPage: Codable {
    
    let results:[Show]
    
}



//
//  Show.swift
//  movieApp
//
//  Created by Lucas Di Lorenzo on 12/12/2021.
//

import Foundation

struct Show: Codable {
    
    let name: String?
    var genre_ids: [Int]?
    let poster_path: String?
    
    let backdrop_path:String?
    let overview:String?
    let first_air_date:String?
    
    let vote_average:Float?
    
}

struct ShowPage: Codable {
    
    let results:[Show]
    
}



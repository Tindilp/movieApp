//
//  webService.swift
//  movieApp
//
//  Created by Lucas Di Lorenzo on 12/12/2021.
//

import Foundation
import Alamofire

private let aKey = "208ca80d1e219453796a7f9792d16776"

private let baseURL = "https://api.themoviedb.org/3/"

private let baseUrlForShows = "tv/popular?api_key="
private let baseUrlForGenres = "genre/tv/list?api_key="

private let lenguageURL = "&language=en-US&"

struct APIClient{
    
    static func getMovies(page:Int, completionHandler: @escaping ([Show])->Void){
        let request = AF.request("\(baseURL)\(baseUrlForShows)\(aKey)\(lenguageURL)page=\(page)")
        request.responseData { response in
            switch response.result {
            case .success(let data):
                do {
                let page = try JSONDecoder().decode(ShowPage.self, from: data)
                completionHandler(page.results )
                } catch let error {
                    print("Unable to load data: \(error)")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    static func getGenre(completionHandler: @escaping ([Genre])->Void){
        let request = AF.request("\(baseURL)\(baseUrlForGenres)\(aKey)\(lenguageURL)")
        request.responseData { response in
            switch response.result {
            case .success(let data):
                do {
                let page = try JSONDecoder().decode(Genres.self, from: data)
                completionHandler(page.genres)
                } catch let error {
                    print("Unable to load data: \(error)")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

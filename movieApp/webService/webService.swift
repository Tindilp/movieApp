//
//  webService.swift
//  movieApp
//
//  Created by Lucas Di Lorenzo on 12/12/2021.
//

import Foundation
import Alamofire

//typealias ResultShowHandler = (_ pageMovie: PageShowDTO) -> Void
//typealias ErrorHandler = (_ errorMessage: String) -> Void
//typealias ShowHandler = (_ arrayMovies: [Show]) -> Void

let aKey = "208ca80d1e219453796a7f9792d16776"
let baseUrlForShows = "https://api.themoviedb.org/3/tv/"
let baseUrlForGenres = "https://api.themoviedb.org/3/genre/tv/"

class APIClient{
    
    static func getMovies(page:Int, completionHandler: @escaping ([Show])->Void){
        let request = AF.request("\(baseUrlForShows)top_rated?api_key=\(aKey)&language=en-US&page=\(page)")
        request.responseData { response in
            switch response.result {
            case .success(let data):
                do {
                let page = try JSONDecoder().decode(ShowPage.self, from: data)
                completionHandler(page.results )
                //print(page.results)
                } catch let error {
                    print("Unable to load data: \(error)")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }

    static func getGenre(completionHandler: @escaping ([Genre])->Void){
        let request = AF.request("\(baseUrlForGenres)list?api_key=\(aKey)&language=en-US")
        request.responseData { response in
            switch response.result {
            case .success(let data):
                do {
                let page = try JSONDecoder().decode(Genres.self, from: data)
                completionHandler(page.genres)
                //print(page.genres)
                } catch let error {
                    print("Unable to load data: \(error)")
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
}

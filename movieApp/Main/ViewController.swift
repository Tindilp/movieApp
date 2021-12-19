//
//  ViewController.swift
//  movieApp
//
//  Created by Lucas Di Lorenzo on 12/12/2021.
//

import UIKit

class ViewController: UIViewController, SearchViewControllerDelegate, DetailViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var results:[Show] = []
    var recomended:[Show] = []
    var genres:[Genre] = []
    
    var isLoadin = false
    var page = 1
    var maxPages = 10
    var value:[String] = []
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.value = AppDelegate.getUserDefaultArrayStringForKey("moviesStored") ?? []
        
        self.loadFavShows()
        self.loadRecomendedShows()
        self.loadGenre()
    }
    
    private func loadGenre(){
        APIClient.getGenre (completionHandler:{ genress in
            self.genres.append(contentsOf: genress)
            self.tableView.reloadData()
        })
    }
    
    // Delegate para actualizar el listado cuando cambia favorito en el detalle
    func dataChangedInDetail(str: String) {
        DispatchQueue.main.async {
            self.loadFavShows()
            self.collectionView.reloadData()
        }
        print(str)
    }
    
    func dataChangedInSearchList(str: String) {
        DispatchQueue.main.async {
            self.loadFavShows()
            self.collectionView.reloadData()
        }
        print(str)
    }
    
    // cargamos los shows que fueron seleccionados como favoritos
    private func loadFavShows(){
        isLoadin = true
        while (results.count < value.count) && (self.page < self.maxPages) {
            APIClient.getMovies(page:self.page, completionHandler:{ show in
                for i in show {
                    if self.value.contains(i.name ?? "-"){
                        self.results.append(i)
                    }
                }
                self.collectionView.reloadData()
                self.isLoadin = false
            })
            self.page+=1
        }
        self.page = 1
    }
    
    private func loadRecomendedShows(){
        isLoadin = true
        let randomPage = Int.random(in: 1..<10)
        APIClient.getMovies(page:randomPage, completionHandler:{ show in
                for i in show {
                    if i.vote_average ?? 5.0 > 8.0 {
                        self.recomended.append(i)
                    }
                }
                self.tableView.reloadData()
                self.isLoadin = false
            })
    }
   
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? DataCollectionViewCell
        cell?.configure(for: results[indexPath.row])
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedShow = UIStoryboard.init(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        selectedShow.show = results[indexPath.row]
        selectedShow.delegate = self
        self.present(selectedShow, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == results.count - 5{
            guard !isLoadin else {
                return
            }
            page+=1
            loadFavShows()
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recomended.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecomendedCollectionViewCell") as! RecomendedCollectionViewCell
        let show = recomended[indexPath.row]
        let gen = self.obtenerGeneros(genero: show.genre_ids?[0] ?? 0)
        cell.configure(for: show, genre: gen)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        let selectedShow = UIStoryboard.init(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        selectedShow.show = self.recomended[indexPath.row]
        selectedShow.delegate = self
        self.present(selectedShow, animated: true, completion: nil)
       
    }
    
    func obtenerGeneros(genero:Int) -> String {
        var test:String = ""
        for tipoGeneros in genres {
            if tipoGeneros.id == genero{
                let nom = tipoGeneros.name ?? ""
                test = nom
            }
        }
        return test
    }
    
}



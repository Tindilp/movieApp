//
//  ViewController.swift
//  movieApp
//
//  Created by Lucas Di Lorenzo on 12/12/2021.
//

import UIKit

class ViewController: UIViewController, SearchViewControllerDelegate, DetailViewControllerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var results:[Show] = []
    
    var isLoadin = false
    var page = 1
    var maxPages = 10
    var value:[String] = []
    let vc2 = DetailViewController()
    
    var recomendedResult:[Show] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.value = AppDelegate.getUserDefaultArrayStringForKey("moviesStored") ?? []
        self.loadShows(page: page)
    }
    
    // Delegate para actualizar el listado cuando cambia favorito en el detalle
    func dataChangedInDetail(str: String) {
        self.loadShows(page: page)
        self.collectionView.reloadData()
        print(str)
    }
    
    func dataChangedInSearchList(str: String) {
        self.loadShows(page: page)
        self.collectionView.reloadData()
        print(str)
    }
    
    // cargamos los shows que fueron seleccionados como favoritos
    private func loadShows(page: Int){
        isLoadin = true
        while (results.count < value.count) && (self.page < self.maxPages) {
            APIClient.getMovies(page:self.page, completionHandler:{ show in
                for i in show {
                    if self.value.contains(i.name ?? "-"){
                        self.results.append(i)
                    }
                    if ((i.vote_average ?? 6) > 9.5) {
                        self.recomendedResult.append(i)
                    }
                }
                self.collectionView.reloadData()
                self.isLoadin = false
            })
            self.page+=1
        }
        self.page = 1
        print(self.results.count)
        print(self.recomendedResult.count)
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
            loadShows(page: page)
        }
    }
    
}



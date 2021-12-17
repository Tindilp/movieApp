//
//  ViewController.swift
//  movieApp
//
//  Created by Lucas Di Lorenzo on 12/12/2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var results:[Show] = []
    
    var isLoadin = false
    var page = 1
    var maxPages = 10
    var value:[String] = []
    var isLoadingViewController = false
    let vc2 = DetailViewController()
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.isLoadingViewController = true
        self.value = AppDelegate.getUserDefaultArrayStringForKey("moviesStored") ?? []
        self.loadMovies(page: page)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//           super.viewWillAppear(animated)
//           print("aca")
//           vc2.completionHandler = { [weak self] () -> Void in
//               self!.loadMovies(page: 1)
//            }
//            collectionView.reloadData()
////            if isLoadingViewController {
////                        isLoadingViewController = false
////            } else {
////                loadMovies(page: 1)
////            }
//        }
    
    private func loadMovies(page: Int){
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
    
    @IBAction func verUsr(_ sender: Any) {
        
        if let value = AppDelegate.getUserDefaultArrayStringForKey("moviesStored"){
       
           print(value)
        } else{
            print("error")
        }
    }
    
    @IBAction func searchBtnPressed(_ sender: Any) {
        
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
        self.present(selectedShow, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == results.count - 5{
            guard !isLoadin else {
                return
            }
            page+=1
            loadMovies(page: page)
        }
    }
    
}



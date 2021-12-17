//
//  SearchViewController.swift
//  movieApp
//
//  Created by Lucas Di Lorenzo on 12/12/2021.
//


import UIKit

class SearchViewController: UIViewController {
    
    var results:[Show] = []
    var genres:[Genre] = []
    var isLoadin = false
    var page = 1
    
    var showList = [Show]()
    var searchedShow = [Show]()
    var searching = false

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listaShows: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        searchBar.showsCancelButton = true
        searchBar.setValue("Cancelar", forKey: "cancelButtonText")
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.white
        
        self.searchBar.delegate = self
        let searchTextField = self.searchBar.searchTextField
        searchTextField.textColor = UIColor.white
        searchTextField.clearButtonMode = .never
        searchTextField.backgroundColor = UIColor(named: "myBlack")
        
        listaShows.dataSource = self
        listaShows.delegate = self
        
        loadMovies(page: page)
        loadGenre()
    }
    
    func getStringGenre( gnre:[String])-> String{
        var textGenre = ""
        for g in gnre{
            textGenre += "| \(g) |"
        }
        return textGenre
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func loadGenre(){
        APIClient.getGenre (completionHandler:{ genress in
            self.genres.append(contentsOf: genress)
            self.listaShows.reloadData()
        })
    }
    
    private func loadMovies(page: Int){
        isLoadin = true
        APIClient.getMovies(page:page, completionHandler:{ show in
            self.results.append(contentsOf: show)
            self.listaShows.reloadData()
            self.isLoadin = false
        })
    }
    
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedShow = results.filter { $0.name!.lowercased().prefix(searchText.count) == searchText.lowercased() }
        searching = true
        listaShows.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        listaShows.reloadData()
    }
}

extension SearchViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if searching {
           return searchedShow.count
       } else {
           return results.count
       }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchViewCell") as! SearchViewCell
       
        if searching {
            let show = searchedShow[indexPath.row]
            let generos = obtenerGeneros(generos: show.genre_ids ?? [])
            cell.configure(for: show, gnre: generos)
        } else {
            let show = results[indexPath.row]
            let generos = obtenerGeneros(generos: show.genre_ids ?? [])
            cell.configure(for: show, gnre: generos)
        }
        return cell
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        let selectedShow = UIStoryboard.init(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        selectedShow.show = results[indexPath.row]
        self.present(selectedShow, animated: true, completion: nil)
    }
    
    
}

//MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath:IndexPath){
        if indexPath.row == results.count - 5{
            guard !isLoadin else {
                return
            }
            page+=1
            loadMovies(page: page)
        }
    }
    

    
    func obtenerGeneros(generos:[Int]) -> [String]{
        var test:[String]=[]
        for tipoGeneros in genres {
            for genreShow in generos{
                if (tipoGeneros.id == genreShow){
                    let nom = tipoGeneros.name ?? ""
                    test.append(nom)
                }
            }
        }
        return test
    }
}

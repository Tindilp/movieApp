//
//  SearchViewCell.swift
//  movieApp
//
//  Created by Lucas Di Lorenzo on 12/12/2021.
//

import Foundation
import UIKit
import Kingfisher

class SearchViewCell: UITableViewCell {
    
    var controller = SearchViewController()
    
    @IBOutlet weak var imgShow: UIImageView!
    @IBOutlet weak var titleShow: UILabel!
    @IBOutlet weak var descriptionShow: UILabel!
    @IBOutlet weak var btnAgregar: UIButton!
    
    
    let borderAlpha : CGFloat = 0.5
    let cornerRadius : CGFloat = 5.0
    
    var strUrl:String = "https://image.tmdb.org/t/p/w500"
    
    override func awakeFromNib(){
        super.awakeFromNib()

        btnAgregar.frame = CGRect(x: 100, y: 100, width: 90, height: 17)
        btnAgregar.setTitle("AGREGAR", for: UIControl.State.normal)
        btnAgregar.setTitleColor(UIColor(named: "myGray"), for: UIControl.State.normal)
        btnAgregar.backgroundColor = UIColor.clear
        btnAgregar.layer.borderWidth = 1.0
        btnAgregar.layer.borderColor = UIColor(named: "myGray")?.cgColor
        btnAgregar.layer.cornerRadius = cornerRadius
        imgShow.layer.cornerRadius = 12
        imgShow.clipsToBounds = true
    }
    
    @IBAction func btnAgregarPressed(_ sender: UIButton) {
        AppDelegate.userDefaultAlreadyExist("moviesStored") ? searchTitleStored() : createMovieStoreAndAppend()
    }
    
    func configure (for show:Show, gnre:[String]){
                
        titleShow.text = show.name
      
        let gen = controller.getStringGenre(gnre: gnre)
        descriptionShow.text = gen
        
        let poster = "\(strUrl)\(show.poster_path ?? " ")"
        if let imageUrl = URL(string: poster){
                   imgShow.kf.setImage(with: imageUrl)
            
        /// aca es para cambiar el boton en caso de que se encuentre agregada la pelicula a las favoritas
        if let shows = AppDelegate.getUserDefaultArrayStringForKey("moviesStored"){
            if shows.contains(show.name!){
                self.fillButton()
            }
        } else {
            print( "No hay shows agregados" )
        }
        }
    }
    
    func searchTitleStored() {
        let arrayDefault = getArrayUserDefault()
        let text = self.titleShow.text!
        let elem = arrayDefault?.filter({ $0.contains(text)})
        (elem?.count ?? Int() > 0) ? removeTitle() : checkTitleOrEmpty()
        UserDefaults.standard.synchronize()
    }

    override func prepareForReuse() {
        self.updateButton()
    }

    func removeTitle() {
        removeTitleFromUserDefault()
    }

    func checkTitleOrEmpty() {
        if UserDefaults.standard.array(forKey: "moviesStored") != nil {
            appendTitleToUserDefault()
        }else {
            createMovieStoreAndAppend()
        }
    }

    func appendTitleToUserDefault(){
        var arrayUserDefaults = getArrayUserDefault()
        arrayUserDefaults?.append(self.titleShow.text ?? String())
        updateUserDefaultWith(arrayUserDefaults ?? [String]())
        self.fillButton()
    }

    func removeTitleFromUserDefault() {
        var arrayDefault = getArrayUserDefault()
        let index = arrayDefault?.firstIndex(of: self.titleShow.text ?? String()) ?? Int()
        arrayDefault?.remove(at: index)
        updateUserDefaultWith(arrayDefault ?? [String]())
        self.emptyButton()
    }

    func createMovieStoreAndAppend() {
        updateUserDefaultWith([String]())
        let elem = self.titleShow.text ?? String()
        var arrayUserDefaults = getArrayUserDefault()
        arrayUserDefaults?.append(elem)
        updateUserDefaultWith(arrayUserDefaults ?? [String]())
        self.fillButton()
    }

    func checkIconHeart(){
        if let userDefault = getArrayUserDefault(), userDefault.count > 0 {
            let results = userDefault.filter({ $0.contains(self.titleShow.text!)})
            (results.count > 0) ? self.fillButton() : self.emptyButton()
        }
    }

    func emptyButton(){
        self.btnAgregar.setTitle("AGREGAR", for: UIControl.State.normal)
        self.btnAgregar.backgroundColor = UIColor.clear
        self.btnAgregar.setTitleColor(UIColor(named: "myGray"), for: .normal)
    }

    func fillButton() {
        self.btnAgregar.setTitle("AGREGADO", for: UIControl.State.normal)
        self.btnAgregar.setTitleColor(UIColor(named: "myBlack"), for: .normal)
        self.btnAgregar.backgroundColor = UIColor(named: "myGray")
        
    }

    func updateUserDefaultWith(_ value: [String]){
        UserDefaults.standard.setValue(value, forKey: "moviesStored")
    }

    func getArrayUserDefault() -> [String]? {
        AppDelegate.getUserDefaultArrayStringForKey("moviesStored")
    }

    func updateButton(){
        DispatchQueue.main.async {
            self.checkIconHeart()
        }
    }
    }


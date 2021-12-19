//
//  DetailViewController.swift
//  movieApp
//
//  Created by Lucas Di Lorenzo on 15/12/2021.
//

import Foundation
import UIKit
import Kingfisher

protocol DetailViewControllerDelegate {
    func dataChangedInDetail(str: String)
}

class DetailViewController: UIViewController{
    
    var delegate: DetailViewControllerDelegate?
    
    var show: Show?
    
    var strUrl:String = "https://image.tmdb.org/t/p/w500"
    
    @IBOutlet weak var backgroundColor: UIImageView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    @IBOutlet weak var suscrpitionBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
     
    var color:UIColor = .clear
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configComponents()
        self.setColorButton()
    }
    
    ///pintamos el boton si este esta o no suscrito a favoritos
    private func setColorButton(){
        if let shows = AppDelegate.getUserDefaultArrayStringForKey("moviesStored"){
            if shows.contains(show?.name ?? "-"){
                self.fillButton()
            } else{
                self.emptyButton()
            }
        } else {
            print( "No hay shows agregados" )
        }
    }
    
    private func configComponents(){
        /// configuracion del boton para volver al listado
        backBtn.layer.cornerRadius = backBtn.frame.width/2
        backBtn.layer.masksToBounds = true
        
        /// configuracion del boton para suscribirse
        suscrpitionBtn.layer.cornerRadius = 25
        suscrpitionBtn.layer.masksToBounds = true
        
        /// seteamos el titulo de la pelicula
        titleLabel.text = "\(show?.name ?? " ")"
        
        /// seteo del año de la pelicula
        let year = show?.first_air_date ?? "1900-01-01"
        yearLabel.text = String(year.prefix(4))
        
        /// seteo de la descripcion de la pelicula
        descriptionLable.text = "\(show?.overview ?? " ")"
        
        /// carga del poster de la pelicula y seteo de propiedades
        let poster = "\(strUrl)\(show?.poster_path ?? " ")"
        if let imageUrl = URL(string: poster){
            posterImage.kf.setImage(with: imageUrl)}
        posterImage.layer.cornerRadius = 20
        posterImage.layer.masksToBounds = true
        posterImage.layer.shadowColor = UIColor.black.cgColor
        posterImage.layer.shadowOffset = CGSize.zero
        posterImage.layer.shadowRadius = 10
        posterImage.layer.shadowOpacity = 1
        
        /// obtenemos el color dominante del poster para usarlo de fondo y lo seteamos
        guard let imageView = posterImage.image else {return}
        color = imageView.averageColor ?? .black
        backgroundColor.backgroundColor = color.withAlphaComponent(0.7)
        
        /// obtenemos y seteamos la imagen de fondo
        var background:String
        if show?.backdrop_path != nil {
            background = "\(strUrl)\(show?.backdrop_path ?? " ")"
        } else {
            background = "\(strUrl)\(show?.poster_path ?? " ")" }
        if let imageUrl = URL(string: background){
            backgroundImage.kf.setImage(with: imageUrl)}
        backgroundImage.image = backgroundImage.image?.withAlpha(0.2)
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.dataChangedInDetail(str: "from Detail")
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func suscriptBtn(_ sender: Any) {
        AppDelegate.userDefaultAlreadyExist("moviesStored") ? searchTitleStored() : createMovieStoreAndAppend()
    }
    
    func searchTitleStored() {
        let arrayDefault = getArrayUserDefault()
        let text = self.titleLabel.text!
        let elem = arrayDefault?.filter({ $0.contains(text)})
        (elem?.count ?? Int() > 0) ? removeTitle() : checkTitleOrEmpty()
        UserDefaults.standard.synchronize()
    }
    
    func createMovieStoreAndAppend() {
        updateUserDefaultWith([String]())
        let elem = self.titleLabel.text ?? String()
        var arrayUserDefaults = getArrayUserDefault()
        arrayUserDefaults?.append(elem)
        updateUserDefaultWith(arrayUserDefaults ?? [String]())
        self.fillButton()
    }
    
    func getArrayUserDefault() -> [String]? {
        AppDelegate.getUserDefaultArrayStringForKey("moviesStored")
    }
    
    func updateUserDefaultWith(_ value: [String]){
        UserDefaults.standard.setValue(value, forKey: "moviesStored")
    }
    
    func removeTitle() {
        removeTitleFromUserDefault()
    }
    
    func removeTitleFromUserDefault() {
        var arrayDefault = getArrayUserDefault()
        let index = arrayDefault?.firstIndex(of: self.titleLabel.text ?? String()) ?? Int()
        arrayDefault?.remove(at: index)
        updateUserDefaultWith(arrayDefault ?? [String]())
        self.emptyButton()
    }
    
    func checkTitleOrEmpty() {
        if UserDefaults.standard.array(forKey: "moviesStored") != nil {
            appendTitleToUserDefault()
        }else {
            createMovieStoreAndAppend()
        }
    }
    
    func fillButton(){
        self.suscrpitionBtn.setTitle("SUSCRIPTO", for: .normal)
        self.suscrpitionBtn.backgroundColor = .white
        self.suscrpitionBtn.setTitleColor(color, for: .normal)
    }

    func emptyButton() {
        self.suscrpitionBtn.setTitle("SUSCRIBIRME", for: .normal)
        self.suscrpitionBtn.setTitleColor(.white, for: .normal)
        self.suscrpitionBtn.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.suscrpitionBtn.layer.borderWidth = 3.0
        self.suscrpitionBtn.layer.borderColor = UIColor.white.cgColor
    }
    
    func appendTitleToUserDefault(){
        var arrayUserDefaults = getArrayUserDefault()
        arrayUserDefaults?.append(self.titleLabel.text ?? String())
        updateUserDefaultWith(arrayUserDefaults ?? [String]())
        self.fillButton()
    }
}

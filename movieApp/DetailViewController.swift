//
//  DetailViewController.swift
//  movieApp
//
//  Created by Lucas Di Lorenzo on 15/12/2021.
//

import Foundation
import UIKit

class DetailViewController: UIViewController{
    
    var show: Show?
    
    var strUrl:String = "https://image.tmdb.org/t/p/w500"
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var descriptionLable: UILabel!
    
    @IBOutlet weak var suscrpitionBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backBtn.layer.cornerRadius = 0.5 * backBtn.bounds.size.width
        backBtn.clipsToBounds = true
        
        titleLabel.text = "\(show?.name ?? " ")"
        
        let year = show?.first_air_date ?? "1900-01-01"
        yearLabel.text = String(year.prefix(4))
        
        descriptionLable.text = "\(show?.overview ?? " ")"
        
        let poster = "\(strUrl)\(show?.poster_path ?? " ")"
        if let imageUrl = URL(string: poster){
            posterImage.kf.setImage(with: imageUrl)}
        
        posterImage.layer.cornerRadius = 8
        
        let background = "\(strUrl)\(show?.backdrop_path ?? " ")"
        if let imageUrl = URL(string: background){
            backgroundImage.kf.setImage(with: imageUrl)}
        
        backgroundImage.alpha = 0.4
        
        suscrpitionBtn.layer.cornerRadius = 25
        
        if let shows = AppDelegate.getUserDefaultArrayStringForKey("moviesStored"){
            if shows.contains(show?.name ?? "-"){
                suscrpitionBtn.setTitle("SUSCRIPTO", for: .normal)
                suscrpitionBtn.backgroundColor = .white
                suscrpitionBtn.setTitleColor(.black, for: .normal)
            } else{
                suscrpitionBtn.setTitle("NO SUSCRIPTO", for: .normal)
                suscrpitionBtn.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                suscrpitionBtn.setTitleColor(.black, for: .normal)
                suscrpitionBtn.layer.borderWidth = 1.0
                suscrpitionBtn.layer.borderColor = UIColor.black.cgColor
            }
        } else {
            print( "No hay shows agregados" )
        }
        
    }
    
    @IBAction func suscriptBtn(_ sender: Any) {
    }
    
}

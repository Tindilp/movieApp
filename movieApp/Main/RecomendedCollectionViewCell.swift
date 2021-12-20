//
//  RecomendedCollectionViewCell.swift
//  movieApp
//
//  Created by Lucas Di Lorenzo on 18/12/2021.
//

import Foundation
import UIKit
import Kingfisher

class RecomendedCollectionViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imagePoster: UIImageView!
    @IBOutlet weak var colorTintImage: UIImageView!
    @IBOutlet weak var genreLbl: UILabel!
    
    var strUrl:String = "https://image.tmdb.org/t/p/w500"
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
        /// Seteamos el color de la celda cuando presionamos sobre ella
        let selectedView = UIView()
        selectedView.backgroundColor = .darkGray
        self.selectedBackgroundView = selectedView

        self.imagePoster.layer.cornerRadius = 15
        imagePoster.clipsToBounds = true
        colorTintImage.layer.cornerRadius = 15
        colorTintImage.clipsToBounds = true
       
    }
    
    func configure (for show:Show, genre:String){
       
        titleLbl.text = show.name
        
        genreLbl.text = genre
        
        var backgroundImage:String
        if show.backdrop_path != nil {
            backgroundImage = "\(strUrl)\(show.backdrop_path ?? " ")"
        } else {
            backgroundImage = "\(strUrl)\(show.poster_path ?? " ")" }
                
        let poster = backgroundImage
        if let imageUrl = URL(string: poster){
            imagePoster.kf.setImage(with: imageUrl)
        }

    }

    
}

//
//  DataCollectionViewCell.swift
//  movieApp
//
//  Created by Lucas Di Lorenzo on 17/12/2021.
//

import Foundation
import UIKit
import Kingfisher

class DataCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var image: UIImageView!
    
    var strUrl:String = "https://image.tmdb.org/t/p/w500"
    
    override func awakeFromNib(){
        super.awakeFromNib()
        image.layer.cornerRadius = 15
        image.clipsToBounds = true
        
    }

    /// Configurmos la celda de la pantalla principal con solo el poster de los show marcados como favoritos
    func configure (for show:Show){
                
        let poster = "\(strUrl)\(show.poster_path ?? " ")"
        if let imageUrl = URL(string: poster){
            image.kf.setImage(with: imageUrl)
        }}
}

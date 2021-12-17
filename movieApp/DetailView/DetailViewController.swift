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
        
        backBtn.layer.cornerRadius = backBtn.frame.width/2
        backBtn.layer.masksToBounds = true
        
        titleLabel.text = "\(show?.name ?? " ")"
        
        let year = show?.first_air_date ?? "1900-01-01"
        yearLabel.text = String(year.prefix(4))
        
        descriptionLable.text = "\(show?.overview ?? " ")"
        
        let poster = "\(strUrl)\(show?.poster_path ?? " ")"
        if let imageUrl = URL(string: poster){
            posterImage.kf.setImage(with: imageUrl)}
        
        posterImage.layer.cornerRadius = 20
        posterImage.layer.masksToBounds = true
        posterImage.layer.shadowColor = UIColor.black.cgColor
        posterImage.layer.shadowOffset = CGSize.zero
        posterImage.layer.shadowRadius = 10
        posterImage.layer.shadowOpacity = 1
        
        guard let imageView = posterImage.image else {return}
        color = imageView.averageColor ?? .black
    
        backgroundColor.backgroundColor = color.withAlphaComponent(0.7)
        var background:String
        if show?.backdrop_path != nil {
            background = "\(strUrl)\(show?.backdrop_path ?? " ")"
        } else {
            background = "\(strUrl)\(show?.poster_path ?? " ")" }
        if let imageUrl = URL(string: background){
            backgroundImage.kf.setImage(with: imageUrl)}
        backgroundImage.image = backgroundImage.image?.withAlpha(0.2)
        
        suscrpitionBtn.layer.cornerRadius = 25
        suscrpitionBtn.layer.masksToBounds = true
//        self.suscrpitionBtn.titleLabel?.font = UIFont(name:"Kailasa-Bold", size: 26.0)
//        self.suscrpitionBtn.setNeedsDisplay()
        
        if let shows = AppDelegate.getUserDefaultArrayStringForKey("moviesStored"){
            if shows.contains(show?.name ?? "-"){
                suscrpitionBtn.setTitle("SUSCRIPTO", for: .normal)
                suscrpitionBtn.backgroundColor = .white
                suscrpitionBtn.setTitleColor(color, for: .normal)
            } else{
                suscrpitionBtn.setTitle("SUSCRIBIRME", for: .normal)
                suscrpitionBtn.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                suscrpitionBtn.setTitleColor(.white, for: .normal)
                suscrpitionBtn.layer.borderWidth = 3.0
                suscrpitionBtn.layer.borderColor = UIColor.white.cgColor
            }
        } else {
            print( "No hay shows agregados" )
        }
        
    }
    
    public var completionHandler:(()->Void)?
        
    
    @IBAction func backBtn(_ sender: Any) {
        self.completionHandler?()
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

extension UIImage {
    
    
    func withAlpha(_ a: CGFloat) -> UIImage {
           return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { (_) in
               draw(in: CGRect(origin: .zero, size: size), blendMode: .normal, alpha: a)
           }}
    
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

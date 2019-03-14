//
//  CurrencyTableViewCell.swift
//  Koku
//
//  Created by HoangVu on 3/14/19.
//  Copyright © 2019 HoangVu. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var flagView: UIImageView!
    @IBOutlet weak var currencyDetailLbel: UILabel!
    @IBOutlet weak var countryNameLbel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func set(currency: CurrencyModel) {
        
        if let imgPath = Bundle.main.path(forResource: currency.countryCode, ofType: "png"){
            flagView?.image = UIImage(named: imgPath)
        }
        
        let curString = NSMutableAttributedString(string: "\(currency.id) - \(currency.currencyName)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.8) ,NSAttributedString.Key.font: UIFont .systemFont(ofSize: 15, weight: .thin)])
        curString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location:0,length:4))
        
        currencyDetailLbel.attributedText = curString
        countryNameLbel.text = currency.countryName
    }

}

//
//  CoinTableCell.swift
//  CoinTestApp2
//
//  Created by Apple on 09/09/22.
//

import Foundation
import UIKit

class CoinTableCell: UITableViewCell {

   
    let hStckView : UIStackView = {
        let t = UIStackView()
        t.distribution = .fill
        t.alignment = .center
        t.spacing = 10
        t.axis = .horizontal
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
     let vStckView : UIStackView = {
         let t = UIStackView()
         t.distribution = .fill
         t.spacing = 10
         t.axis = .vertical
         t.translatesAutoresizingMaskIntoConstraints = false
         return t
     }()
    
    
    let imgCoin : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30.0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let lblCoinTitle : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let lblUSDPrice : UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bottomView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
               // self.contentView.backgroundColor = UIColor.blue
                self.contentView.addSubview(hStckView)
                hStckView.addArrangedSubview(imgCoin)
                hStckView.addArrangedSubview(vStckView)
                vStckView.addArrangedSubview(lblCoinTitle)
                vStckView.addArrangedSubview(lblUSDPrice)
                
                hStckView.topAnchor.constraint(equalTo:self.contentView.safeAreaLayoutGuide.topAnchor,constant: 20).isActive = true
                hStckView.leftAnchor.constraint(equalTo:self.contentView.leftAnchor,constant: 20).isActive = true
                hStckView.rightAnchor.constraint(equalTo:self.contentView.rightAnchor,constant: -20).isActive = true
                hStckView.bottomAnchor.constraint(equalTo:self.contentView.bottomAnchor,constant: -20).isActive = true
                imgCoin.heightAnchor.constraint(equalToConstant: 60).isActive = true
                imgCoin.widthAnchor.constraint(equalToConstant: 60).isActive = true
     }

     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()

//
//        // Initialization code
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    var coinData: Coin? {
        didSet {
            self.lblCoinTitle.text = "Loading..."
            self.lblUSDPrice.text = "Loading..."
//            self.textLabel?.numberOfLines = 0
//            self.textLabel?.text = coinData?.name ?? ""
            self.getCoinDetail(coinID: coinData?.id)
        }
    }
    
    
    
    func getCoinDetail(coinID:String?){
        if let coinID = coinID {
            let coin = coinID.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let url = "https://api.coingecko.com/api/v3/coins/\(coin)"
           
            APIManager.API.sendRequest(url, CoinDetailResponse.self) { response in
                DispatchQueue.main.async {
                   print(response)
                    if let url =  response.image?.large{
                        self.imgCoin.loadRemoteImageFrom(urlString: url )
                    }
                    self.lblCoinTitle.text = response.name ?? ""
                    self.lblUSDPrice.text = "$\(response.market_data?.current_price?.usd ?? 0.0)"
                    let lastUpdatedPrice = response.market_data?.price_change_24h ?? 0.0
                    lastUpdatedPrice > 0 ? (self.lblUSDPrice.textColor = .green) : (self.lblUSDPrice.textColor = .red)
                }
            } failureCompletion: { failure in
                
            }
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.lblCoinTitle.text = "Loading..."
        self.lblUSDPrice.text = "Loading..."
        self.imgCoin.image = nil
    }
    

}

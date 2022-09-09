//
//  CoinDetailVC.swift
//  CoinTestApp2
//
//  Created by Apple on 09/09/22.
//

import UIKit

class CoinDetailVC: UIViewController {
    
    
    lazy var sv: UIScrollView = {
        let object = UIScrollView()
        object.showsHorizontalScrollIndicator = false
        object.showsVerticalScrollIndicator = false
        object.backgroundColor = UIColor.white
        object.translatesAutoresizingMaskIntoConstraints = false
        return object
    }()
    
    
    let containerView : UIStackView = {
        let t = UIStackView()
        t.distribution = .fill
        t.spacing = 16
        t.axis = .vertical
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    
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
        t.spacing = 6
        t.axis = .vertical
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    let imgCoin : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50.0
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let lblCoinTitle : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lblDescription : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let lblUSDPrice : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let lblBTCsPrice : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let btnBuy : UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.titleLabel?.textAlignment = .center
        button.setTitle("Buy", for: .normal)
        button.backgroundColor = UIColor.blue
        button.layer.cornerRadius = 25.0
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let bottomView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var coinID : String?
    var coinDetailObj:CoinDetailResponse?
    var timer = Timer()
    
    // LifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool)  {
        super.viewWillAppear(animated)
        self.getCoinDetail()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.getCoinDetail()
        })
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer.invalidate()
    }

    // Private Methods
    private func setupView(){
        self.title = self.coinID ?? ""
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(sv)
        sv.addSubview(containerView)
        containerView.addArrangedSubview(hStckView)
        containerView.addArrangedSubview(lblDescription)
        hStckView.addArrangedSubview(imgCoin)
        hStckView.addArrangedSubview(vStckView)
        vStckView.addArrangedSubview(lblCoinTitle)
        vStckView.addArrangedSubview(lblUSDPrice)
        vStckView.addArrangedSubview(lblBTCsPrice)
        containerView.addArrangedSubview(btnBuy)
        containerView.addArrangedSubview(bottomView)
        self.btnBuy.addTarget(self, action: #selector(btnBuyAction), for: .touchUpInside)
    }
    
    private func setupConstraint(){
        sv.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor,constant: 0).isActive = true
        sv.leftAnchor.constraint(equalTo:view.leftAnchor,constant: 20).isActive = true
        sv.rightAnchor.constraint(equalTo:view.rightAnchor,constant: -20).isActive = true
        sv.bottomAnchor.constraint(equalTo:view.bottomAnchor,constant: 0).isActive = true
        imgCoin.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imgCoin.heightAnchor.constraint(equalToConstant: 100).isActive = true
        btnBuy.heightAnchor.constraint(equalToConstant: 50).isActive = true
        containerView.topAnchor.constraint(equalTo:sv.topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo:sv.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo:sv.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo:sv.bottomAnchor).isActive = true
        let widthConstraint  = NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: sv, attribute: .width, multiplier: 1, constant: 0)
        sv.addConstraints([widthConstraint])
    }
    
    
    // Action Methods
    @objc func btnBuyAction(sender:UIButton){
        print("click")
        let coinPurchaseVC = CoinPurchaseVC()
        coinPurchaseVC.coinDetailObj = self.coinDetailObj
        self.navigationController?.pushViewController(coinPurchaseVC, animated: true)
    }
    
    func getCoinDetail(){
        if let coinID = coinID {
            let url = "https://api.coingecko.com/api/v3/coins/\(coinID)"
            APIManager.API.sendRequest(url, CoinDetailResponse.self) { response in
                DispatchQueue.main.async {
                    print(response)
                    self.coinDetailObj = response
                    if let url =  response.image?.large{
                        self.imgCoin.loadRemoteImageFrom(urlString: url )
                    }
                    self.lblUSDPrice.text = "Price (USD):- $\(response.market_data?.current_price?.usd ?? 0.0)"
                    self.lblBTCsPrice.text = "Price (BTC):- $\(response.market_data?.current_price?.btc ?? 0.0)"
                    self.lblCoinTitle.text = response.name ?? ""
                    self.lblDescription.text = response.description?.en ?? ""
                }
            } failureCompletion: { failure in
                
            }
        }
        
    }
}


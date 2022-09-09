//
//  CoinPurchaseVC.swift
//  CoinTestApp2
//
//  Created by Apple on 09/09/22.
//

import UIKit

class CoinPurchaseVC: UIViewController {
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
    
    let lblQty : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20,weight: .heavy)
        label.numberOfLines = 0
        label.text = "Quantity"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lblPrice : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20,weight: .heavy)
        label.numberOfLines = 0
        label.text = "Price"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let txtPrice : UITextField = {
        let textField = UITextField()
        textField.placeholder = "Please enter Price (USD)"
        textField.keyboardType = .decimalPad
        
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let txtQty : UITextField = {
        let textField = UITextField()
        
        textField.borderStyle = .roundedRect
        textField.placeholder = "Please enter Quantity"
        textField.keyboardType = .decimalPad
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
    
    
    
    
    var coinDetailObj:CoinDetailResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupConstraint()
    }
    
    
    
    // Private Methods
    private func setupView(){
        self.title = "Purchase Coin"
        self.lblQty.text = self.coinDetailObj?.name ?? ""
        self.view.backgroundColor = .white
        self.view.addSubview(sv)
        sv.addSubview(containerView)
        containerView.addArrangedSubview(lblQty)
        containerView.addArrangedSubview(txtQty)
        containerView.addArrangedSubview(lblPrice)
        containerView.addArrangedSubview(txtPrice)
        containerView.addArrangedSubview(btnBuy)
        txtQty.delegate = self
        txtPrice.delegate = self
        txtQty.text = "1"
        txtPrice.text = "\(self.coinDetailObj?.market_data?.current_price?.usd ?? 0.0)"
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard(_:))))
        self.btnBuy.addTarget(self, action: #selector(btnBuyAction), for: .touchUpInside)

    }
    
    private func setupConstraint(){
        sv.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor,constant: 30).isActive = true
        sv.leftAnchor.constraint(equalTo:view.leftAnchor,constant: 20).isActive = true
        sv.rightAnchor.constraint(equalTo:view.rightAnchor,constant: -20).isActive = true
        sv.bottomAnchor.constraint(equalTo:view.bottomAnchor,constant: 0).isActive = true
        containerView.topAnchor.constraint(equalTo:sv.topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo:sv.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo:sv.rightAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo:sv.bottomAnchor).isActive = true
        let widthConstraint  = NSLayoutConstraint(item: containerView, attribute: .width, relatedBy: .equal, toItem: sv, attribute: .width, multiplier: 1, constant: 0)
        sv.addConstraints([widthConstraint])
        btnBuy.heightAnchor.constraint(equalToConstant: 50).isActive = true
        txtPrice.heightAnchor.constraint(equalToConstant: 50).isActive = true
        txtQty.heightAnchor.constraint(equalToConstant: 50).isActive = true
                
    }
    
    @objc func hideKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    
    @objc func btnBuyAction(sender:UIButton){
        if let strPrice = self.txtPrice.text,let strQty = self.txtQty.text,let price = Double(strPrice),let qty = Double(strQty){
            if price > 0.0 && qty > 0.0{
                let message = "Congratulations on buying \(self.coinDetailObj?.name ?? "")! You have bought \(self.txtQty.text ?? "") of \(self.coinDetailObj?.name ?? "") for $\(self.txtPrice.text ?? ""). "
                let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
                    self.navigationController?.popToRootViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }

    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}



extension CoinPurchaseVC : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            if textField == self.txtQty{
                if let price = self.coinDetailObj?.market_data?.current_price?.usd,let qty = Double(updatedText){
                    self.txtPrice.text = "\(price*qty)"
                }
                
            }
            if textField == self.txtPrice{
                if let price = self.coinDetailObj?.market_data?.current_price?.usd,let amount = Double(updatedText){
                    self.txtQty.text = "\(amount/price)"
                }
                
            }
            
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txtQty.text == ""{
            txtQty.text = "1"
            txtPrice.text = "\(self.coinDetailObj?.market_data?.current_price?.usd ?? 0.0)"
        }
    }
}


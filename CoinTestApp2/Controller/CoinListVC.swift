//
//  CoinListVC.swift
//  CoinTestApp2
//
//  Created by Apple on 09/09/22.
//

import UIKit

class CoinListVC: UIViewController {
    
    let tblCoinList : UITableView = {
        let t = UITableView()
        t.translatesAutoresizingMaskIntoConstraints = false
        return t
    }()
    
    var coinList : [Coin] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.getCoinList()
         self.loadDataFromFile()
    }

    // Private Methods
    private func setupView(){
        self.title = "Coin List"
        self.view.addSubview(tblCoinList)
        tblCoinList.delegate = self
        tblCoinList.dataSource = self
        tblCoinList.register(CoinTableCell.self, forCellReuseIdentifier: "cell")
    }
    
    private func setupConstraint(){
        tblCoinList.topAnchor.constraint(equalTo:view.topAnchor).isActive = true
        tblCoinList.leftAnchor.constraint(equalTo:view.leftAnchor).isActive = true
        tblCoinList.rightAnchor.constraint(equalTo:view.rightAnchor).isActive = true
        tblCoinList.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
    }
    
    // Load data From JSON file
    func loadDataFromFile() {
        if let path = Bundle.main.path(forResource: "coins-list", ofType: "json") {
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                  if let coinList = try? JSONDecoder().decode([Coin].self, from: data){
                      DispatchQueue.main.async {
                          self.coinList = coinList
                          self.tblCoinList.reloadData()
                      }
                    }
              } catch {
                  print(error);
              }
        }
    }
    
    
    
    // API Call
    func getCoinList(){
        APIManager.API.sendRequest("https://api.coingecko.com/api/v3/coins/list", [Coin].self) { response in
            DispatchQueue.main.async {
                self.coinList = response
                self.tblCoinList.reloadData()
            }
        } failureCompletion: { failure in
            print(failure.localizedDescription);
        }
    }
    
}


extension CoinListVC : UITableViewDataSource,UITableViewDelegate{
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coinList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CoinTableCell
        cell.coinData = self.coinList[indexPath.row]
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    
    
    // MARK: - Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // etc
        let coinDetailVC = CoinDetailVC()
        coinDetailVC.coinID = self.coinList[indexPath.row].id ?? ""
        self.navigationController?.pushViewController(coinDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


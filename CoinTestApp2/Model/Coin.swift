//
//  Coin.swift
//  CoinTestApp2
//
//  Created by Apple on 09/09/22.
//

import Foundation



struct Coin : Codable {
    let id : String?
    let symbol : String?
    let name : String?
    enum CodingKeys: String, CodingKey {

        case id = "id"
        case symbol = "symbol"
        case name = "name"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
        
    }

}

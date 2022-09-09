//
//  CoinDetailResponse.swift
//  CoinTestApp2
//
//  Created by Apple on 09/09/22.
//

import Foundation

struct Current_price : Codable {
    let btc : Double?
    let usd : Double?
    enum CodingKeys: String, CodingKey {
        case btc = "btc"
        case usd = "usd"
        
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        usd = try values.decodeIfPresent(Double.self, forKey: .usd)
        btc = try values.decodeIfPresent(Double.self, forKey: .btc)
    }
}

struct Market_data : Codable {
    let current_price : Current_price?
    let price_change_24h : Double?
    enum CodingKeys: String, CodingKey {
        case current_price = "current_price"
        case price_change_24h = "price_change_24h"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        current_price = try values.decodeIfPresent(Current_price.self, forKey: .current_price)
        price_change_24h = try values.decodeIfPresent(Double.self, forKey: .price_change_24h)
    }
}

struct Links : Codable {
    let homepage : [String]?
    let official_forum_url : [String]?
    let twitter_screen_name : String?
    let subreddit_url : String?
    
    enum CodingKeys: String, CodingKey {
        case homepage = "homepage"
        case official_forum_url = "official_forum_url"
        case twitter_screen_name = "twitter_screen_name"
        case subreddit_url = "subreddit_url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        homepage = try values.decodeIfPresent([String].self, forKey: .homepage)
        official_forum_url = try values.decodeIfPresent([String].self, forKey: .official_forum_url)
        twitter_screen_name = try values.decodeIfPresent(String.self, forKey: .twitter_screen_name)
        subreddit_url = try values.decodeIfPresent(String.self, forKey: .subreddit_url)
    }

}


struct Image : Codable {
    let thumb : String?
    let small : String?
    let large : String?

    enum CodingKeys: String, CodingKey {

        case thumb = "thumb"
        case small = "small"
        case large = "large"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        thumb = try values.decodeIfPresent(String.self, forKey: .thumb)
        small = try values.decodeIfPresent(String.self, forKey: .small)
        large = try values.decodeIfPresent(String.self, forKey: .large)
    }

}




struct Description : Codable {
    let en : String?
    
    enum CodingKeys: String, CodingKey {
        case en = "en"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        en = try values.decodeIfPresent(String.self, forKey: .en)
    }

}


struct CoinDetailResponse : Codable {
    let id : String?
    let market_data : Market_data?
    let symbol : String?
    let name : String?
    let description : Description?
    let links : Links?
    let image : Image?
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case market_data = "market_data"
        case symbol = "symbol"
        case name = "name"
        case description = "description"
        case links = "links"
        case image = "image"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        market_data = try values.decodeIfPresent(Market_data.self, forKey: .market_data)
        symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(Description.self, forKey: .description)
        links = try values.decodeIfPresent(Links.self, forKey: .links)
        image = try values.decodeIfPresent(Image.self, forKey: .image)
    }

}


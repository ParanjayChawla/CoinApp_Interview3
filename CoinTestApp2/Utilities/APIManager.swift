//
//  APIManager.swift
//  CoinTestApp2
//
//  Created by Apple on 09/09/22.
//

import Foundation

enum WebError: Error {
    ///400
    case badRequest
    ///409
    case conflictError
    ///403
    case forbidden
    ///500
    case internalServerError
    ///404
    case notFound
    ///503
    case serviceUnavailable
    ///401
    case unauthorized
    ///419
    case tokenExpired//authorizedTimeout
    ///422
    case unprocessAble
    
    case timeout
    
    case cancel
    
    case unknown
    
    case custom(String?)
    
    case noData
    
    case noInternet
    
    case hostFail
    
    case parseFail
    
    
    static func getErrorByCode(_ statusCode: Int!, message : String) -> WebError {
        return .custom(message)
    }
    
    var statusCode: Int {
        switch self {
        case .badRequest:
            return 400
        case .conflictError:
            return 409
        case .forbidden:
            return 403
        case .internalServerError:
            return 500
        case .notFound:
            return 404
        case .serviceUnavailable:
            return 503
        case .unauthorized:
            return 401
        case .tokenExpired:
            return 419
        case .unprocessAble:
            return 422
        case .noData:
            return 0
        case .noInternet:
            return 0
        case .hostFail:
            return 0
        case .parseFail:
            return 0
        case .timeout:
            return 0
        case .cancel:
            return 0
        case .unknown:
            return 0
        case .custom(_):
            return 0
        }
    }
    
    var errorMessage: String? {
        
        switch self {
        case .badRequest: //400
            return "Bad request"
        case .conflictError: //409
            return "ConflictError"
        case .forbidden: //403
            return "You do not have access to requested data."
        case .internalServerError: //500
            return "InternalServerError"
        case .notFound: //404
            return "NotFound"
        case .serviceUnavailable : //503
            return "ServiceUnavailable"
        case .unauthorized: //401
            return "You are not authorised."
        case .tokenExpired:
            return "Token is expired."
        case .unprocessAble:
            return "Unprocessable request"
        case .noData:
            return "No data found."
        case .noInternet:
            return "Network not reachable."
        case .hostFail:
            return "Failed to retrieve host."
        case .parseFail:
            return "Failed to parse data."
        case .timeout:
            return "Request timed out."
        case .cancel:
            return "Canceled request."
        case .unknown:
            return "There is an error processing your request. Please try again later."
        case .custom(let errorMessage) :
            return errorMessage
        }
    }
}

final class APIManager {
    
   
    
    static let API: APIManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForResource = 60
        configuration.timeoutIntervalForRequest = 60
        configuration.httpMaximumConnectionsPerHost = 20
        let apiManager = APIManager()
        return apiManager
    }()
    
       
    
    func sendRequest<T: Codable>(_ url:String ,_ type: T.Type,  successCompletion: @escaping (_ response: T) -> Void, failureCompletion: @escaping ( _ failure: WebError) -> Void) {
        
        if let url = URL(string: url){
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    if let coinList = try? JSONDecoder().decode(T.self, from: data){
                       successCompletion(coinList)
                    }
                } else if let error = error {
                    print("HTTP Request Failed \(error)")
                }
            }
            task.resume()
        }
    }
    
}



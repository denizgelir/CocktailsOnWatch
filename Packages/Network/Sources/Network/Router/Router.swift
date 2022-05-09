//
//  Router.swift
//  Network
//
//  Created by Deniz Gelir on 17.03.2022.
//

import Foundation

public protocol NetworkProtocol {
    var baseURL: String { get }
    var apiKey: String { get }
    var url: URL { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

public enum Router: NetworkProtocol {
    
    case getDrinksForCategory(category: String)
    case getCocktailDetailsById(id: String)
    
    public var baseURL: String {
        return "https://www.thecocktaildb.com/api/json/v1/" + apiKey
    }
    
    public var apiKey: String {
        return "1"
    }
    
    public var httpMethod: HTTPMethod {
        return .get
    }
    
    public var headers: HTTPHeaders? {
        return nil
    }
    
    public var url: URL {
        switch self {
        case .getDrinksForCategory:
            let queryString = baseURL + "/filter.php"
            let url = URL(string: queryString)!
            return url
        case .getCocktailDetailsById:
            let queryString = baseURL + "/lookup.php"
            let url = URL(string: queryString)!
            return url
        }
    }
    
    public var encoding: ParameterEncoding {
        return .urlEncoding
    }
    
    public var task: HTTPTask {
        switch self {
        case .getDrinksForCategory(let category):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: encoding,
                                      urlParameters: ["c" : category])
        case .getCocktailDetailsById(let id):
            return .requestParameters(bodyParameters: nil,
                                      bodyEncoding: encoding,
                                      urlParameters: ["i" : id])
        }
    }
}


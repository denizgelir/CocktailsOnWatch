//
//  API.swift
//  Network
//
//  Created by Deniz Gelir on 18.03.2022.
//

import Foundation

public protocol APIProtocol {
    func getDrinksFor(category: String, completion: @escaping (Result<DrinkList, NetworkError>) -> ())
    func getCocktailDetailsById(id: String, completion: @escaping (Result<DrinkList, NetworkError>) -> ())
}

public class API: APIProtocol {
    
    private let networkManager: NetworkManager<Router>
    
    public init(networkManager: NetworkManager<Router> = NetworkManager<Router>()) {
        self.networkManager = networkManager
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<Bool, NetworkError> {
        switch response.statusCode {
        case 200...299: return .success(true)
        case 401...500: return .failure(NetworkError.authenticationError)
        case 501...599: return .failure(NetworkError.badRequest)
        case 600: return .failure(NetworkError.outdated)
        default: return .failure(NetworkError.failed)
        }
    }
}

public extension API {
    
    func getCocktailDetailsById(id: String, completion: @escaping (Result<DrinkList, NetworkError>) -> Void) {
        networkManager.request(.getCocktailDetailsById(id: id)) { (data, response, error) in
            guard error == nil else {
                return completion(.failure(NetworkError.connectionError))
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        return completion(.failure(NetworkError.noData))
                    }
                    guard let apiResponse = try? JSONDecoder().decode(DrinkList.self,
                                                                      from: data)
                    else {
                        return completion(.failure(NetworkError.unableToDecode))
                    }
                    completion(.success(apiResponse))
                case .failure:
                    completion(.failure(NetworkError.failed))
                }
            }
        }
    }
    
    func getDrinksFor(category: String, completion: @escaping (Result<DrinkList, NetworkError>) -> Void) {
        networkManager.request(.getDrinksForCategory(category: category)) { (data, response, error) in
            guard error == nil else {
                return completion(.failure(NetworkError.connectionError))
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let data = data else {
                        return completion(.failure(NetworkError.noData))
                    }
                    guard let apiResponse = try? JSONDecoder().decode(DrinkList.self,
                                                                      from: data)
                    else {
                        return completion(.failure(NetworkError.unableToDecode))
                    }
                    completion(.success(apiResponse))
                case .failure:
                    completion(.failure(NetworkError.failed))
                }
            }
        }
    }
}

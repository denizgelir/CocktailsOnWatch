//
//  NetworkManager.swift
//  Network
//
//  Created by Deniz Gelir on 18.03.2022.
//

import Foundation

public protocol NetworkRouter: AnyObject {
    associatedtype Router: NetworkProtocol
}

public class NetworkManager<Router: NetworkProtocol>: NetworkRouter {

    public typealias NetworkRouterCompletion = (_ data: Data?,
                                                _ response: URLResponse?,
                                                _ error: Error?) -> Void
    public init() {}

    private var task: URLSessionTask?

    public func request(_ route: Router, completion: @escaping NetworkRouterCompletion) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }

    public func cancel() {
        self.task?.cancel()
    }

    fileprivate func buildRequest(from route: Router) throws -> URLRequest {

        var request = URLRequest(url: route.url,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)

        request.httpMethod = route.httpMethod.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            switch route.task {
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):

                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }

    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
}


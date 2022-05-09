//
//  HTTPTask.swift
//  Network
//
//  Created by Deniz Gelir on 18.03.2022.
//

import Foundation

public typealias HTTPHeaders = [String: String]

public enum HTTPTask {
    case requestParameters(bodyParameters: Parameters?,
                           bodyEncoding: ParameterEncoding,
                           urlParameters: Parameters?)
}

public enum HTTPMethod: String {
    case get = "GET"
}

//
//  NetworkError.swift
//  Network
//
//  Created by Deniz Gelir on 18.03.2022.
//

import Foundation

public enum NetworkError: String, Error {
     case authenticationError = "You need to be authenticated first."
     case badRequest = "Bad request"
     case outdated = "The url you requested is outdated."
     case failed = "Network request failed."
     case noData = "Response returned with no data to decode."
     case unableToDecode = "We could not decode the response."
     case connectionError = "Please check your network connection"
     case encodingFailed = "Encoding Failed"
     case missingURL = "Missing Url"
}

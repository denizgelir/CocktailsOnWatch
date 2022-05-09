//
//  NetworkConfig.swift
//  Network
//
//  Created by Deniz Gelir on 17.03.2022.
//

import Foundation

public final class NetworkConfig {

    static var environment: Environment!
    static var isDebug: Bool = false

    public static func configure() {
        #if DEBUG
        isDebug = true
        #endif

        loadFromConfigFile()
    }

    private static func loadFromConfigFile() {

        guard let path =  Bundle.main.path(forResource: "Info", ofType: "plist"),
              let config = NSDictionary(contentsOfFile: path) as? [String: Any] else {
                  fatalError("No found plist file!")
              }

        guard let baseUrl = config["BaseUrl"] as? String else { return }

        environment = Environment(baseUrl: baseUrl)
    }
}

struct Environment {
    let baseUrl: String
}

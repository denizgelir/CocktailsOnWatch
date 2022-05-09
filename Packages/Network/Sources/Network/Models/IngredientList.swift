//
//  IngredientList.swift
//  Network
//
//  Created by Deniz Gelir on 24.03.2022.
//

import Foundation

public struct IngredientList : Codable {
    
    public let ingredients : [Ingredient]?
}

public struct Ingredient : Codable {
    
    public let idIngredient : String?
    public let strABV : String?
    public let strAlcohol : String?
    public let strDescription : String?
    public let strIngredient : String?
    public let strType : String?
}

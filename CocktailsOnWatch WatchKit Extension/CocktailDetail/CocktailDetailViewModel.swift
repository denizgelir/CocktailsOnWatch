//
//  CocktailDetailViewModel.swift
//  CocktailsOnWatch WatchKit Extension
//
//  Created by Deniz Gelir on 9.05.2022.
//

import Foundation
import Network

protocol CocktailDetailViewModelDelegate: AnyObject {
    func loadData(state: CocktailDetailViewModel.State)
}

final class CocktailDetailViewModel {

    enum State {
        case loading
        case success
        case error(message: String)
    }

    weak var delegate: CocktailDetailViewModelDelegate?

    private let api: APIProtocol

    var drink: Drink?

    init(api: APIProtocol = API()) {
        self.api = api
    }
    
    func getCocktailDetailsBy(id: String) {
        self.delegate?.loadData(state: .loading)
        api.getCocktailDetailsById(id: id) { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.drink = response.drinks?.first
                self.delegate?.loadData(state: .success)
            case .failure(let error):
                self.delegate?.loadData(state: .error(message: error.rawValue))
            }
        }
    }
}

extension CocktailDetailViewModel {
    
    var cocktailInstructions: String? {
        return drink?.strInstructions
    }
}

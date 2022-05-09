//
//  CocktailListViewModel.swift
//  CocktailsOnWatch WatchKit Extension
//
//  Created by Deniz Gelir on 26.04.2022.
//

import Foundation
import Network

protocol CocktailListViewModelDelegate: AnyObject {
    func loadData(state: CocktailListViewModel.State)
}

final class CocktailListViewModel {

    enum State {
        case loading
        case success
        case error(message: String)
    }

    weak var delegate: CocktailListViewModelDelegate?

    private let api: APIProtocol

    var drinkList: [Drink] = []

    init(api: APIProtocol = API()) {
        self.api = api
    }
    
    func getDrinkList() {
        self.delegate?.loadData(state: .loading)
        api.getDrinksFor(category: "Cocktail") { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.drinkList = response.drinks ?? []
                self.delegate?.loadData(state: .success)
            case .failure(let error):
                self.delegate?.loadData(state: .error(message: error.rawValue))
            }
        }
    }
}

// MARK: - UITableView Data
extension CocktailListViewModel {
    
    var numberOfRows: Int {
        return drinkList.count
    }
    
    func getItem(at index: Int) -> Drink? {
        return drinkList[index]
    }
}

//
//  CocktailListInterfaceController.swift
//  CocktailsOnWatch WatchKit Extension
//
//  Created by Deniz Gelir on 26.04.2022.
//

import WatchKit
import Network
import Foundation
import Kingfisher

class CocktailListInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var tableView: WKInterfaceTable!
    
    private let viewModel = CocktailListViewModel()
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        viewModel.delegate = self
        viewModel.getDrinkList()
    }
    
    func loadTableData() {
        tableView.setNumberOfRows(viewModel.numberOfRows, withRowType: "CocktailRow")
        
        for i in 0 ..< viewModel.numberOfRows {
            let cocktail = viewModel.getItem(at: i)
            if let row = tableView.rowController(at: i) as? CocktailRow {
                row.titleLabel.setText(cocktail?.strDrink)
                let url = URL(string: cocktail?.strDrinkThumb ?? "")
                row.cocktailImage.kf.setImage(with: url)
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        guard let cocktail = viewModel.getItem(at: rowIndex) else { return }
        self.presentController(withName: "CocktailDetail", context: cocktail.idDrink)
    }
    
}

extension CocktailListInterfaceController: CocktailListViewModelDelegate {
    
    func loadData(state: CocktailListViewModel.State) {
        DispatchQueue.main.async {
            switch state {
            case .loading:
                print("Loading")
            case .success:
                self.loadTableData()
            case .error(let message):
                print(message)
            }
        }
    }
}

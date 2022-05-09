//
//  CocktailDetailInterfaceController.swift
//  CocktailsOnWatch WatchKit Extension
//
//  Created by Deniz Gelir on 9.05.2022.
//

import WatchKit
import Foundation

final class CocktailDetailInterfaceController: WKInterfaceController {
    
    @IBOutlet weak var detailLabel: WKInterfaceLabel!
    
    private let viewModel = CocktailDetailViewModel()
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        viewModel.delegate = self
        if let id = context as? String {
            viewModel.getCocktailDetailsBy(id: id)
        }
    }
    
}

extension CocktailDetailInterfaceController: CocktailDetailViewModelDelegate {

    func loadData(state: CocktailDetailViewModel.State) {
        DispatchQueue.main.async {
            switch state {
            case .loading:
                print("Loading")
            case .success:
                self.detailLabel.setText(self.viewModel.cocktailInstructions)
            case .error(let message):
                print(message)
            }
        }
    }
}

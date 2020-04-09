//
//  ViewController.swift
//  TaskRx
//
//  Created by Alexey on 09.04.2020.
//  Copyright © 2020 Alexey. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

let coctailCellIdeintifier = "CoctailCellIdentifier"

class CoctailsListViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
      super.viewDidLoad()
      let results = searchBar.rx.text.orEmpty
        .throttle(.seconds(1), scheduler: MainScheduler.instance)
        .distinctUntilChanged()
        .flatMapLatest { query -> Observable<[Drink]> in
          if query.isEmpty {
            return .just([])
          }
            return CoctailService.shared.searchDrinks(searchString: query).catchErrorJustReturn([])
        }
        .observeOn(MainScheduler.instance)

      results
        .bind(to: tableView.rx.items(cellIdentifier: coctailCellIdeintifier, cellType: DrinkTableViewCell.self)) { (index, drink: Drink, cell) in
            cell.textLabel?.text = drink.title
            cell.instructions = drink.instructions
        }
        .disposed(by: disposeBag)
        
      tableView.rx.itemSelected
          .subscribe(onNext: { [weak self] indexPath in
            if let cell = self?.tableView.cellForRow(at: indexPath) as? DrinkTableViewCell {
                let alertController = UIAlertController(title: "Instructions", message: cell.instructions, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                    alertController.dismiss(animated: true, completion: nil)
                }))
                self?.present(alertController, animated: true, completion: nil)
            }
          })
          .disposed(by: disposeBag)
    }


}


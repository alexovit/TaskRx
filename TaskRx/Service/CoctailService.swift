//
//  AnimalService.swift
//  TaskRx
//
//  Created by Alexey on 09.04.2020.
//  Copyright © 2020 Alexey. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CoctailService {
    
    static let shared = CoctailService()

    func searchDrinks(searchString: String) -> Observable<[Drink]> {
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=\(searchString)") else {
            return Observable.of([])
        }

        return RxApi.requestGet(url: url)
            .filter { objects in
                return !objects.isEmpty
            }
            .map { objects in
                if let drinks = objects["drinks"] as? [[String: Any]] {
                    return drinks.compactMap(Drink.init)
                } else {
                    return []
                }
            }
    }
    
}

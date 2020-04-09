//
//  Drink.swift
//  TaskRx
//
//  Created by Alexey on 09.04.2020.
//  Copyright © 2020 Alexey. All rights reserved.
//

import UIKit

struct Drink: Codable {
    let title: String
    let instructions: String

    init?(dictionary: [String: Any]) {
        guard let title = dictionary["strDrink"] as? String,
            let instructions = dictionary["strInstructions"] as? String
            else {
                return nil
        }

        self.title = title
        self.instructions = instructions
    }
}

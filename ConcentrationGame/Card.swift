//
//  Card.swift
//  ConcentrationGame
//
//  Created by Borna on 07/05/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import Foundation

struct Card{
    var id: Int
    var isFaceUp = false {
        didSet{
            if isFaceUp {
                isSeen = true
            }
        }
    }
    var isMatched = false
    var isSeen = false
    
    init (id: Int) {
        self.id = id
    }
}

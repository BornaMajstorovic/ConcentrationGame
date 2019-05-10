//
//  Concentration.swift
//  ConcentrationGame
//
//  Created by Borna on 07/05/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import Foundation

class Concentration{
    
    private(set) var cardsArray = [Card]()
    var scoreCount = 0
    var flipCount = 0
    
    static var matchPoints = 2
    static var faceUpPenalty = 1
  
    
    var indexOfOnlyOneFaceUpCard: Int? {
        get{
            var choosenIndex: Int?
            for index in cardsArray.indices {
                if cardsArray[index].isFaceUp {
                    guard choosenIndex == nil else{
                        return nil
                    }
                    choosenIndex = index
                }
            }
            return choosenIndex
        }
        set{
            for index in cardsArray.indices {
                cardsArray[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func chooseCard(at index: Int){
        assert(cardsArray.indices.contains(index), "Index out of range")
        
        if !cardsArray[index].isMatched {
            if let matchedIndex = indexOfOnlyOneFaceUpCard, index != matchedIndex {
                if cardsArray[index].id == cardsArray[matchedIndex].id {
                    
                    cardsArray[matchedIndex].isMatched = true
                    cardsArray[index].isMatched = true
                    scoreCount += Concentration.matchPoints
                } else{
                    if cardsArray[index].isSeen {
                        scoreCount -= Concentration.faceUpPenalty
                    }
                }
                cardsArray[index].isFaceUp = true;
            } else {
                indexOfOnlyOneFaceUpCard = index 
            }
        }
        flipCount += 1
    }
    
    init(numberOfPairs: Int){
        assert(numberOfPairs > 0, "You need to have at least 1 pair of cards")
        
        var beforeShuffel: [Card] = []
        
        for index in 1...numberOfPairs {
            let card = Card(id: index)
            beforeShuffel += [card,card]
        }
        //  shuffel array of cards so that matched cards don't end up
        //  in the same space every time new game button is selected
        while !beforeShuffel.isEmpty {
            let randomIndex = (beforeShuffel.count-1).arc4Random
            let card = beforeShuffel.remove(at: randomIndex)
            cardsArray.append(card)
        }
    }
    
}

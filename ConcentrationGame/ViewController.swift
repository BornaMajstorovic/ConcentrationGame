//
//  ViewController.swift
//  ConcentrationGame
//
//  Created by Borna on 07/05/2019.
//  Copyright © 2019 Borna. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var scoreCountLabel: UILabel!
    
    @IBAction private func touchCard(_ sender: UIButton) {
    
        if let cardNumber = cardButtons.index(of: sender){
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            flipCountLabel.text = "Flips: \(game.flipCount)"
            scoreCountLabel.text = "Score: \(game.scoreCount)"
        } else {
            print("THE choosen one was not in cardButtons array")
        }
    }
    
    @IBAction private func newGame(_ sender: UIButton) {
        setupGame()
    }
    
    private var game : Concentration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGame()
    }
    
    private func setupGame() {
        theme = newTheme
        game = Concentration(numberOfPairs: (cardButtons.count + 1)/2)
        //sets to 0 every new game both flipcount and scorecount
        flipCountLabel.text = "Flips: \(game.flipCount)"
        scoreCountLabel.text = "Score: \(game.scoreCount)"
        emoji = [:]
        emojiArray = theme.emojiArray
    }
    
    typealias themeAlias = ( emojiArray : [String], backgroundColor : UIColor, cardColor : UIColor)
    
    private let themeMap: [String: themeAlias] = [
        "faces": ( ["😪","😴","😜","🤗","😘","😰","🤬","😅"], #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1) , #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)),
        "animals": (["🐶", "🙊", "🐧", "🦁", "🐆", "🐄", "🐿", "🐠"], #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)),
        "healty": (["🍏", "🥑", "🍇", "🍒", "🍑", "🥝", "🍐", "🍎"], #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)),
        "fastfood": (["🍔","🍟","🍕","🥐","🌭","🌮","🦴","🥓"], #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)),
        "sports": (["⚽️","⛸","⛹🏿‍♀️","🥋","🏂","🎳","🥊","🎾"], #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1))
    ]
    
    private var newTheme: themeAlias{
        let index = themeMap.count.arc4Random
        let key = Array(themeMap.keys)[index]
        return themeMap[key]!
    }
    
    private var theme: themeAlias! {
        didSet{
            view.backgroundColor = theme.backgroundColor
            for button in cardButtons{
                button.backgroundColor = theme.cardColor
                button.setTitle("", for: UIControl.State.normal)
            }
            flipCountLabel.textColor = theme.cardColor
            scoreCountLabel.textColor = theme.cardColor
            emojiArray = theme.emojiArray
        }
    }
    
    private var emoji =  [Int : String]()
    private var emojiArray: [String]!
    
    private func emoji(for card: Card) -> String {
        if emoji[card.id] == nil, emojiArray.count > 0 {
            let index = Int(arc4random_uniform(UInt32(emojiArray.count - 1)))
            emoji[card.id] = emojiArray.remove(at: index)
        }
        return emoji[card.id] ?? "?"
    }
    
    private func updateViewFromModel(){
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cardsArray[index]
            
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor =  #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ?  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) :  #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
}


extension Int{
    var arc4Random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}

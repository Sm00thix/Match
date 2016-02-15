//
//  GameModel.swift
//  Match
//
//  Created by Ole Engstrøm on 10/11/15.
//  Copyright © 2015 Ole Engstroem. All rights reserved.
//

import UIKit

class GameModel: NSObject {
    
    func getCards() -> [Card] {
        
        
        var generatedCards:[Card] = [Card]()
        
        // TODO: generate some card objects
        for _ in 0...7 {
            
            // Generate a random number
            let randNumber:Int = Int(arc4random_uniform(13))
            
            // Create a new card object
            let firstCard:Card = Card()
            firstCard.cardValue = randNumber
            
            // Create second card object
            let secondCard:Card = Card()
            secondCard.cardValue = randNumber
            
            // Place card objects into the array
            generatedCards += [firstCard, secondCard]
            
        }
        
        // Randomize the cards
        for index in 0...generatedCards.count-1 {
            
            // Currenct card
            let currentCard:Card = generatedCards[index]
            
            // Randomly choose another index
            let randomIndex:Int = Int(arc4random_uniform(16))
            
            // Swap objects at the two indexes
            
            generatedCards[index] = generatedCards[randomIndex]
            generatedCards[randomIndex] = currentCard
            
            print(String(format: "swapping card %d with card %d", index, randomIndex))
        }
        
        return generatedCards
        
    }
}

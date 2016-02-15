//
//  ViewController.swift
//  Match
//
//  Created by Ole Engstrøm on 10/11/15.
//  Copyright © 2015 Ole Engstroem. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // Storyboard properties
    @IBOutlet weak var cardScrollview: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var countdownLabel: UILabel!
    
    var gameModel:GameModel = GameModel()
    var cards:[Card] = [Card]()
    var revealedCard:Card?
    var timer:NSTimer!
    var countDown:Int = 30
    
    // Audio player properties
    var correctSoundPlayer:AVAudioPlayer!
    var wrongSoundPlayer:AVAudioPlayer!
    var shuffleSoundPlayer:AVAudioPlayer!
    var flipSoundPlayer:AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Initialize the audio players
        do {
            let correctSoundUrl:NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("dingcorrect", ofType: "wav")!)
            
            self.correctSoundPlayer = try AVAudioPlayer(contentsOfURL: correctSoundUrl)
        }
        
        catch {
            // If some error occurs, execution comes into here
        }
        
        do {
            let wrongSoundUrl:NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("dingwrong", ofType: "wav")!)
            
            self.wrongSoundPlayer = try AVAudioPlayer(contentsOfURL: wrongSoundUrl)
        }
            
        catch {
            // If some error occurs, execution comes into here
        }
        
        do {
            let shuffleSoundUrl:NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("shuffle", ofType: "wav")!)
            
            self.shuffleSoundPlayer = try AVAudioPlayer(contentsOfURL: shuffleSoundUrl)
        }
            
        catch {
            // If some error occurs, execution comes into here
        }
        
        do {
            let flipSoundUrl:NSURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cardflip", ofType: "wav")!)
            
            self.flipSoundPlayer = try AVAudioPlayer(contentsOfURL: flipSoundUrl)
        }
            
        catch {
            // If some error occurs, execution comes into here
        }
        
        // Get the cards from the game model
        self.cards = self.gameModel.getCards()
        
        // Layout cards
        self.layoutCards()
        
        // Play the shuffle sound
        self.shuffleSoundPlayer.play()
        
        // Start the timer
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "timerUpdate", userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func timerUpdate() {
        
        // Decrement the counter
        countDown--
        
        // Update countdown label
        self.countdownLabel.text = String(countDown)
        
        
        
        var allCardsMatched:Bool = true
        for card in self.cards {
            
            if card.isDone == false {
                allCardsMatched = false
                break
            }
        } // end for loop
        
        if allCardsMatched == true {
            countDown = 0
        }
        

        if countDown == 0 {
            
            // Stop the timer
            self.timer.invalidate()
            
            // Game is over, check if there is at least one unmatched card
            var allCardsMatched:Bool = true
            
            for card in self.cards {
                
                if card.isDone == false {
                    allCardsMatched = false
                    break
                }
            } // end for loop
            
            var alertText:String = ""
            
            if allCardsMatched == true {
                
                // Win
                alertText = "Game Won!"
                
            }
            else {
                
                // Lose
                alertText = "Game Lost!"
            }
            
            let alert:UIAlertController = UIAlertController(title: "Game Over!", message: alertText, preferredStyle: UIAlertControllerStyle.Alert)
            
            // Restart the game
            let restartAction = UIAlertAction(title: "Alright!", style: UIAlertActionStyle.Cancel, handler: {
                
                UIAlertAction in
                
                
                
            })
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func layoutCards() {
        
        var columnCounter:Int = 0
        var rowCounter:Int = 0
        
        // Loop through each card in the array
        for index in 0...self.cards.count - 1 {
            
            // Place the card in the view and turn off translateautoresizingmask
            let thisCard:Card = self.cards[index]
            thisCard.translatesAutoresizingMaskIntoConstraints = false
            self.contentView.addSubview(thisCard)
            
            let tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "cardTapped:")
            
            thisCard.addGestureRecognizer(tapGestureRecognizer)
            
            // Set the height and width contraints
            let heightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 170)
            
            let widthConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 120)
            
            thisCard.addConstraints([heightConstraint, widthConstraint])
            
            // Set the horizontal position
            if columnCounter > 0 {
                // Card is not in the first column
                let cardOnTheLeft:Card = self.cards[index - 1]
                
                let leftMarginConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: cardOnTheLeft, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 5)
                
                // Add constraint
                self.contentView.addConstraint(leftMarginConstraint)
                
            }
            else {
                // Card is in the first column
                let leftMarginConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
                
                // Add the constraint
                self.contentView.addConstraint(leftMarginConstraint)
            }
            
            // Set the vertical position
            if rowCounter > 0 {
                // Card is not in the first row
                let cardOnTop:Card = self.cards[index - 4]
                
                let topMarginConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: cardOnTop, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 5)
                
                // Add the constraint
                self.contentView.addConstraint(topMarginConstraint)
            }
            else {
                // Card is in the first row
                let topMarginConstraint:NSLayoutConstraint = NSLayoutConstraint(item: thisCard, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 10)
                
                // Add constraint
                self.contentView.addConstraint(topMarginConstraint)
            }
            
            
            // Increment the column counter
            columnCounter++
            
            // if the column reaches the 5th column, reset it and increment the row counter
            if columnCounter >= 4 {
                columnCounter = 0
                rowCounter++
            }
        
        }  // End for loop
        
        // Add height constraint to the content view so that the scrollview knows how much to allow to scroll
        let contentViewHeightConstraint:NSLayoutConstraint = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.cards[0], attribute: NSLayoutAttribute.Height, multiplier: 4, constant: 35)
        
        // Add the constraint
        self.contentView.addConstraint(contentViewHeightConstraint)
        
    } // End layout func
    
    func cardTapped(recognizer:UITapGestureRecognizer) {
        
        // If countdown is 0, then exit
        if self.countDown == 0 {
            return
        }
        
        // Get the card that was tapped
        let cardThatWasTapped:Card = recognizer.view as! Card
        
        // Is the card already flipped up?
        if cardThatWasTapped.isFlipped == false {
            
            // Play flip sound
            self.flipSoundPlayer.play()
            
            // Card is not flipped, now check if it's the first card being flipped
            if self.revealedCard == nil {
                
                // This is the first card being flipped
                // Flip down all the cards
                // self.flipDownAllCards()
                
                //Flip up the card
                cardThatWasTapped.flipUp()
                
                // Set the revealed card
                self.revealedCard = cardThatWasTapped

            }
                
            else {
                // This is the second card being flipped
                
                // Flip up the card
                cardThatWasTapped.flipUp()
                
                // Check if it's a match
                if self.revealedCard?.cardValue == cardThatWasTapped.cardValue {
                    
                    // It's a match
                    self.correctSoundPlayer.play()
                    
                    // TODO: Remove both cards
                    self.revealedCard?.isDone = true
                    cardThatWasTapped.isDone = true
                    
                    // Reset the revealed card
                    self.revealedCard = nil
                    
                }
                
                else {
                    // It's not a match
                    self.wrongSoundPlayer.play()
                    
                    // Flip down both cards
                    let timer1 = NSTimer.scheduledTimerWithTimeInterval(1, target: self.revealedCard!, selector: "flipDown", userInfo: nil, repeats: false)
                    
                    let timer2 = NSTimer.scheduledTimerWithTimeInterval(1, target: cardThatWasTapped, selector: "flipDown", userInfo: nil, repeats: false)
                    
                    // Reset the revealed card
                    self.revealedCard = nil
                }
                
            }
        } // end if statement
        
    }  // end func cardTapped
    
    func flipDownAllCards() {
        
        for card in self.cards {
            
            if card.isDone == false {
                card.flipDown()
            }
            
        }
    
    }
   
}















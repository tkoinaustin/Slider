//
//  Quotes.swift
//  Slider
//
//  Created by Tom Nelson on 9/28/19.
//  Copyright © 2019 TKO Solutions. All rights reserved.
//

import Foundation

struct Quotes {
    static var winningQuotes: [String] = [
        "Best in class",
        "Best in show",
        "Best of breed",
        "Bragging rights",
        "Dress for success",
        "Driven by success",
        "Due a win",
        "First past the post",
        "Heads I win, tails you lose",
        "Hit it out of the park ",
        "King of the castle",
        "Knock it out of the park",
        "Lap of honour",
        "Nothing succeeds like success",
        "Play to win",
        "Recipe for success",
        "Roaring success",
        "Say the magic word ",
        "Success breeds success",
        "Success has many fathers, while failure is an orphan",
        "Sweet smell of success",
        "Sweet taste of success",
        "Tailored for success",
        "The People's Champ ",
        "The winner takes it all, the loser standing small",
        "To the victor goes the spoils",
        "Top marks",
        "Win big",
        "Win by a head",
        "Win by a mile",
        "Win by a neck",
        "Win by a nose",
        "Win the day",
        "Winner takes all",
        "Winner's circle",
        "World beater",
        "World champion",
        "You're the safe bet"
    ]
    
    static var replayQuotes: [String] = [
        "That just never gets old",
        "You just never get tired of that game, do you?",
        "What, again!",
        "Oh the sweet smell of victory",
        "May I have another?",
        "Let me show it to you once more",
        "Care to see it again?"
    ]
    
    static var congratQuotes: [String] = [
        "Good job",
        "Way to go",
        "Congrats",
        "Hi five",
        "👍🏻",
        "🤗",
        "🎉"
    ]

    static var winner: String {
        let index = Int.random(in: 0..<winningQuotes.count)
        return winningQuotes[index]
    }
    
    static var replay: String {
        let index = Int.random(in: 0..<replayQuotes.count)
        return replayQuotes[index]
    }
    
    static var congrats: String {
        let index = Int.random(in: 0..<congratQuotes.count)
        return congratQuotes[index]
    }
}

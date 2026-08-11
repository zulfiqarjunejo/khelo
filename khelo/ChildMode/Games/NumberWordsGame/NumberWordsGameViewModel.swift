//
//  NumberWordsGameViewModel.swift
//  khelo
//
//  Game logic for the Numbers & Words game: shows N objects, speaks the
//  number then the word, and checks the child's tapped answer.
//

import SwiftUI
import Combine

struct CountableObject {
    let emoji: String
    let singular: String
    let plural: String
}

enum NumberWordsCatalog {
    static let objects: [CountableObject] = [
        CountableObject(emoji: "🍎", singular: "apple", plural: "apples"),
        CountableObject(emoji: "⭐️", singular: "star", plural: "stars"),
        CountableObject(emoji: "🚗", singular: "car", plural: "cars"),
        CountableObject(emoji: "🎈", singular: "balloon", plural: "balloons"),
        CountableObject(emoji: "🐟", singular: "fish", plural: "fish"),
        CountableObject(emoji: "⚽️", singular: "ball", plural: "balls"),
        CountableObject(emoji: "🍌", singular: "banana", plural: "bananas"),
        CountableObject(emoji: "🍊", singular: "orange", plural: "oranges"),
        CountableObject(emoji: "🍪", singular: "cookie", plural: "cookies"),
        CountableObject(emoji: "🐶", singular: "dog", plural: "dogs"),
        CountableObject(emoji: "🐱", singular: "cat", plural: "cats"),
        CountableObject(emoji: "🦆", singular: "duck", plural: "ducks"),
        CountableObject(emoji: "🐦", singular: "bird", plural: "birds"),
        CountableObject(emoji: "🦋", singular: "butterfly", plural: "butterflies"),
        CountableObject(emoji: "🌸", singular: "flower", plural: "flowers"),
        CountableObject(emoji: "🧸", singular: "teddy bear", plural: "teddy bears"),
        CountableObject(emoji: "🎁", singular: "gift", plural: "gifts"),
        CountableObject(emoji: "🚂", singular: "train", plural: "trains"),
        CountableObject(emoji: "⛵️", singular: "boat", plural: "boats"),
        CountableObject(emoji: "🪁", singular: "kite", plural: "kites"),
    ]

    static let numberWords = [
        "one", "two", "three", "four", "five",
        "six", "seven", "eight", "nine", "ten",
    ]
}

struct NumberWordsRound {
    let object: CountableObject
    let count: Int

    var word: String {
        count == 1 ? object.singular : object.plural
    }

    var numberWord: String {
        NumberWordsCatalog.numberWords[count - 1]
    }
}

@MainActor
final class NumberWordsGameViewModel: ObservableObject {
    @Published private(set) var round: NumberWordsRound
    @Published private(set) var roundsCompleted = 0

    let announcer = ChildSpeechAnnouncer()

    private let maxCount: Int

    init(maxCount: Int = 10) {
        self.maxCount = maxCount
        self.round = Self.makeRound(maxCount: maxCount, avoiding: nil)
    }

    func speakCurrentRound() {
        announcer.speakNumberAndWord(number: round.numberWord, word: round.word)
    }

    /// Called when the child taps anywhere on screen: move on to a new round.
    func advanceToNextRound() {
        roundsCompleted += 1
        round = Self.makeRound(maxCount: maxCount, avoiding: round)
        speakCurrentRound()
    }

    /// Picks a random count and object, avoiding an exact repeat of the
    /// previous round's count (so the same number never appears twice in a
    /// row) and, where possible, the previous object too.
    private static func makeRound(maxCount: Int, avoiding previous: NumberWordsRound?) -> NumberWordsRound {
        var count: Int
        repeat {
            count = Int.random(in: 1...maxCount)
        } while maxCount > 1 && count == previous?.count

        let objects = NumberWordsCatalog.objects
        var object: CountableObject
        repeat {
            object = objects.randomElement()!
        } while objects.count > 1 && object.singular == previous?.object.singular

        return NumberWordsRound(object: object, count: count)
    }
}

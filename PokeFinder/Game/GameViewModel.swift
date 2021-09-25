//
//  GameViewModel.swift
//  PokeFinder
//
//  Created by Shubroto Shuvo on 8/23/21.
//

import Combine
import Foundation
import SwiftUI

protocol GameViewModel: ObservableObject {
    var currentSession: GameSession! { get }
    var playableString: String { get }
    var shakeHangmanTextAttempt: Int { get }
    var letterUISet: [LetterView.LetterUIStruct] { get }
    
    var letterTappedSubject: PassthroughSubject<Character, Never> { get }
}

enum HangmanGameError {
    case alreadyUsed
    case wrongLetter
    case gameOver
    case none
}

enum HangmanGameState {
    case inProgress, completed
}

class GameViewModelImp: GameViewModel {
    private let pokemons: [Pokemon]
    
    private var gameErrorSubject: CurrentValueSubject<HangmanGameError, Never> = .init(.none)
    private var gameStateSubject: CurrentValueSubject<HangmanGameState, Never> = .init(.inProgress)
    var letterTappedSubject: PassthroughSubject<Character, Never>
    
    var letterUISet: [LetterView.LetterUIStruct] {
        let letters: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        var letterUIStruct: [LetterView.LetterUIStruct] = []
        for letter in letters {
            letterUIStruct.append(LetterView.LetterUIStruct(letter: letter, isUsedByDefault: currentSession.lettersUsed.contains(Character(letter))))
        }
        return letterUIStruct
    }
    
    @Published var currentSession: GameSession!
    @Published var shakeHangmanTextAttempt: Int = 0
    @Published var playableString: String
    
    
    private var completedSession: [GameSession] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(pokemons: [Pokemon]) {
        self.pokemons = pokemons
        self.playableString = ""
        self.letterTappedSubject = PassthroughSubject<Character, Never>()
        
        refreshScreen()
        setBindings()
    }
    
    private func setBindings() {
        letterTappedSubject
            .removeDuplicates()
            .filter({[self] (letter) -> Bool in
                !(self.checkIfLetterUsedInCurrentSession(letter: letter) || isGameOverForCurrentSession)
            })
            .sink {[self] (letter) in
                self.userLetterTappedAction(with: letter)
            }
            .store(in: &cancellables)
        
        gameErrorSubject
            .sink { (error) in
                switch error {
                case .alreadyUsed:
                    print("Already used baby")
                case .wrongLetter:
                    self.handleWrongLetterError()
                case .gameOver:
                    print("Sorry can't play")
                case .none:
                    break
                }
            }
            .store(in: &cancellables)
        
        gameStateSubject
            .sink { (state) in
                switch state {
                case .inProgress:
                    print("Life going on")
                case .completed:
                    self.handleCompletedNextGameSession()
                }
            }
            .store(in: &cancellables)
    }
    
    private func refreshScreen() {
        startGameSession()
        setPlayableString()
    }
    
    private func startGameSession() {
        currentSession = GameSession(pokemon: pokemons[completedSession.count])
    }
    
    private func setPlayableString() {
        var pokemonString = ""
        for letter in Array(currentSession.pokemon.name) {
            pokemonString += ((currentSession.characterMap[letter] ?? false) ? "\(letter)" : "_") + " "
        }
        playableString = String(pokemonString.dropLast())
    }
    
    private func checkIfLetterUsedInCurrentSession(letter: Character) -> Bool {
        currentSession.lettersUsed.contains(letter)
    }
    
    private func userLetterTappedAction(with letter: Character) {
        currentSession.setToCharacterUsed(with: letter)
        guard currentSession.isContainInNameMapAndUpdate(with: letter) else {
            gameErrorSubject.send(.wrongLetter)
            return
        }
        setPlayableString()
        if didUserGuessedAllForCurrentSession {
            gameStateSubject.send(.completed)
        }
    }
    
    private var didUserGuessedAllForCurrentSession: Bool {
        for (_, didGuessed) in currentSession.characterMap {
            if didGuessed == false {
                return false
            }
        }
        return true
    }
    
    private var isGameOverForCurrentSession: Bool {
        currentSession.chances <= 0
    }
    
    private func handleWrongLetterError() {
        currentSession.chances -= 1
        withAnimation(.default) {
            self.shakeHangmanTextAttempt += 1
        }
        if isGameOverForCurrentSession {
            print("Game Over sir")
        }
    }
    
    private func handleCompletedNextGameSession() {
        completedSession.append(currentSession)
        refreshScreen()
        gameStateSubject.send(.inProgress)
    }
}

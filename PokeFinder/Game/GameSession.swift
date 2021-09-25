//
//  GameSession.swift
//  PokeFinder
//
//  Created by Shubroto Shuvo on 9/1/21.
//

import Foundation

struct GameSession {
    var pokemon: Pokemon
    var chances: Int = 5
    var characterMap: [Character:Bool] = [:]
    var lettersUsed: Set<Character> = []
    
    init(pokemon: Pokemon) {
        self.pokemon = pokemon
        self.pokemon.convertNameToUpperCase()
        self.characterMap = getNameMapping()
    }
    
    private mutating func getNameMapping() -> [Character:Bool] {
        let characters = Array(pokemon.name)
        var nameMapping: [Character:Bool] = [:]
        for letter in characters {
            nameMapping[letter] = false
        }
        
        let allKeys = nameMapping.keys
        switch nameMapping.count {
        case 1...3:
            let randElement = allKeys.randomElement()!
            nameMapping[randElement] = true
            setToCharacterUsed(with: randElement)
        default:
            let usedKey = allKeys.randomElement()!
            nameMapping[usedKey] = true
            setToCharacterUsed(with: usedKey)
            while true {
                let newKey = allKeys.randomElement()!
                if usedKey != newKey {
                    nameMapping[newKey] = true
                    setToCharacterUsed(with: newKey)
                    break
                }
            }
        }
        
        return nameMapping
    }
    
    mutating func isContainInNameMapAndUpdate(with character: Character) -> Bool {
        guard let _ = characterMap[character] else {
            return false
        }
        characterMap[character] = true
        return true
    }
    
    mutating func setToCharacterUsed(with char: Character) {
        lettersUsed.insert(char)
    }
}

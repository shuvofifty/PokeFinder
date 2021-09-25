//
//  HomeScreenModel.swift
//  PokeFinder
//
//  Created by Shubroto Shuvo on 8/23/21.
//

import Foundation

protocol HomeScreenModel {
    func getPokemonModels() -> [Pokemon]
}

class HomeScreenModelImp: HomeScreenModel {
    func getPokemonModels() -> [Pokemon] {
        var pokemons = [Pokemon(name: "Pikachu", image: "Pikach"), Pokemon(name: "Raichu", image: "Raichu"), Pokemon(name: "Charmander", image: "Charmander"), Pokemon(name: "zapdos", image: "zapdos")]
        pokemons.shuffle()
        return pokemons
    }
}

struct Pokemon {
    var name: String
    var image: String
    
    mutating func convertNameToUpperCase() {
        name = name.uppercased()
    }
}

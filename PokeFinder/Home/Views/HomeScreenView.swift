//
//  HomeScreenView.swift
//  PokeFinder
//
//  Created by Shubroto Shuvo on 8/1/21.
//

import SwiftUI

struct HomeScreenView: View {
    @State private var showHomeScreen = true
    @State private var showHangmanScreen = false
    
    var homeScreenModel: HomeScreenModel
    
    var howdyTrainerText: some View {
        Text("Howdy Trainer")
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .modifier(TitleLabelModifier())
    }
    
    var letsCatchPokemonText: some View {
        Text("Lets catch some pokemon!")
            .font(.headline)
            .multilineTextAlignment(.center)
            .foregroundColor(Color(Colors.white))
    }
    
    var startGameButton: some View {
        Button(action: {
            withAnimation(.spring()) {
                startGameTappedAnimation()
            }
        }, label: {
            HStack {
                Image("pikachu")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 35, height: 35, alignment: .center)
                    .foregroundColor(Color(Colors.white))
                Text("Start Game")
                    .bold()
            }
        })
        .buttonStyle(PrimaryButtonStyle())
        .padding(.top, 35)
        .padding(.horizontal, 20)
    }
    
    var leaderBoardButton: some View {
        Button(action: {}, label: {
            HStack {
                Image("trophy")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 35, height: 35, alignment: .center)
                    .foregroundColor(Color(Colors.white))
                Text("Leaderboard")
                    .bold()
            }
        })
        .buttonStyle(SecondaryButtonStyle())
        .padding(.top, 5)
        .padding(.horizontal, 20)
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(Colors.Primary))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            VStack {
                if showHomeScreen {
                    VStack {
                        howdyTrainerText
                        letsCatchPokemonText
                    }
                    .transition(.combineFadeTransition(with: .top))
                }
                
                if showHomeScreen {
                    VStack {
                        startGameButton
                        leaderBoardButton
                    }
                    .transition(.combineFadeTransition(with: .bottom))
                }
                
                if showHangmanScreen {
                    VStack {
                        GameScreenView(onCrossTap: {
                            withAnimation(.spring()) {
                                showHangmanScreen = false
                                showHomeScreen = true
                            }
                        }, gameViewModel: GameViewModelImp(pokemons: homeScreenModel.getPokemonModels()))
                        .padding(.horizontal, 10)
                    }
                    .transition(.combineFadeTransition(with: .top))
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
        }
    }
    
    private func startGameTappedAnimation() {
        showHomeScreen = false
        showHangmanScreen = true
    }
}

struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView(homeScreenModel: HomeScreenModelImp())
    }
}

struct TitleLabelModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(Color(Colors.white))
    }
}

extension AnyTransition {
    static func combineFadeTransition(with move: Edge) -> AnyTransition {
        AnyTransition.move(edge: move).combined(with: .opacity)
    }
}

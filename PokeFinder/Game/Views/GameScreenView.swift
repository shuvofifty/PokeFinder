//
//  GameScreenView.swift
//  PokeFinder
//
//  Created by Shubroto Shuvo on 8/1/21.
//

import Combine
import SwiftUI

struct GameScreenView<GameVMGeneric: GameViewModel>: View {
    private var cancellables = Set<AnyCancellable>()
    private var onCrossTap: () -> Void
    @ObservedObject private var gameViewModel: GameVMGeneric
    
    var guessPokemonText: some View {
        Text("Guess The Pokemon")
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .modifier(TitleLabelModifier())
    }
    
    var chooseLetterText: some View {
        Text("Choose a letter:")
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .center)
            .font(.title3)
            .foregroundColor(Color(Colors.white))
        
    }
    
    var hangmanText: some View {
        Text(gameViewModel.playableString)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .font(.title2)
            .foregroundColor(Color(Colors.white))
    }
    
    init(onCrossTap: @escaping () -> Void,
         gameViewModel: GameVMGeneric) {
        self.onCrossTap = onCrossTap
        self.gameViewModel = gameViewModel
    }
    
    var body: some View {
        VStack {
            HStack {
                Image("close")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color(Colors.white))
                    .onTapGesture {
                        onCrossTap()
                    }
                Spacer()
                Text("\(gameViewModel.currentSession.chances)")
                    .fontWeight(.bold)
                    .padding(.all, 10)
                    .overlay(
                        Circle()
                            .stroke(Color(Colors.white), lineWidth: 3)
                    )
                    .font(.title3)
                    .foregroundColor(Color(Colors.white))
                
            }
            Spacer()
            guessPokemonText
                .padding(.bottom, 40)
            Spacer()
            hangmanText
                .padding(.bottom, 80)
                .modifier(Shake(animatableData: CGFloat(gameViewModel.shakeHangmanTextAttempt)))
            Spacer()
            chooseLetterText
            LetterView(letterUIStructs: gameViewModel.letterUISet, numberOfElements: 6, tapLetterSubject: gameViewModel.letterTappedSubject)
        }
        .background(Color(Colors.Primary))
    }
}

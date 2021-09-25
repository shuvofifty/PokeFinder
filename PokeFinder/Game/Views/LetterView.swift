//
//  LetterView.swift
//  PokeFinder
//
//  Created by Shubroto Shuvo on 8/27/21.
//

import Combine
import Foundation
import SwiftUI

struct LetterView: View {
    struct LetterUIStruct: Hashable {
        var letter: String
        var isUsedByDefault: Bool
    }
    
    private let letterUIStructs: [LetterUIStruct]
    private let numberOfElements: Int
    private let tapLetterSubject: PassthroughSubject<Character, Never>
    
    init(letterUIStructs: [LetterUIStruct],
         numberOfElements: Int,
         tapLetterSubject: PassthroughSubject<Character, Never>) {
        self.letterUIStructs = letterUIStructs
        self.numberOfElements = numberOfElements
        self.tapLetterSubject = tapLetterSubject
    }

    var body: some View {
        VStack {
            ForEach(getLetterArrayForView(), id: \.self) { rows in
                HStack {
                    ForEach(rows, id: \.self) { letterUIStruct in
                        LetterButtonView(letter: letterUIStruct.letter, tapSubject: tapLetterSubject, isUsedByDefault: letterUIStruct.isUsedByDefault)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private func getLetterArrayForView() -> [[LetterUIStruct]] {
        var letterUIStructArray: [[LetterUIStruct]] = []
        var rowNumber = 0
        letterUIStructArray.append([])
        for (index, letterUIStruct) in letterUIStructs.enumerated() {
            if index != 0 && index % numberOfElements == 0 {
                rowNumber += 1
                letterUIStructArray.append([])
            }
            letterUIStructArray[rowNumber].append(letterUIStruct)
        }
        return letterUIStructArray
    }
}


struct LetterButtonView: View {
    private var letter: String
    private var isUsedByDefault: Bool
    @State private var isEnable: Bool = true
    
    private let tapSubject: PassthroughSubject<Character, Never>
    
    init(letter: String,
         tapSubject: PassthroughSubject<Character, Never>,
         isUsedByDefault: Bool) {
        self.letter = letter
        self.tapSubject = tapSubject
        self.isUsedByDefault = isUsedByDefault
    }
    
    var body: some View {
        Text(letter)
            .fontWeight(.bold)
            .padding(.all, 12)
            .foregroundColor(Color.white)
            .frame(width: 50, height: 50, alignment: .center)
            .font(.title)
            .background(
                Circle().fill(Color(isEnable ? Colors.Button.primary : Colors.black ))
            )
            .onTapGesture {
                tapSubject.send(Character(letter))
            }
            .onAppear(perform: {
                isEnable = !isUsedByDefault
            })
    }
}

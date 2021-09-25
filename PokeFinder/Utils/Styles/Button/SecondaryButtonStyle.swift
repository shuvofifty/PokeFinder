//
//  SecondaryButtonStyle.swift
//  PokeFinder
//
//  Created by Shubroto Shuvo on 8/22/21.
//

import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.all, 15)
            .foregroundColor(Color.white)
            .overlay(
                Capsule(style: .continuous)
                    .stroke(Color(Colors.Button.primary), lineWidth: 4)
            )
            .font(.title3)
    }
}

//
//  PrimaryButtonStyle.swift
//  PokeFinder
//
//  Created by Shubroto Shuvo on 8/1/21.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding(.all, 15)
            .background(
                Capsule().fill(Color(Colors.Button.primary))
            )
            .foregroundColor(Color.white)
            .font(.title3)
    }
}

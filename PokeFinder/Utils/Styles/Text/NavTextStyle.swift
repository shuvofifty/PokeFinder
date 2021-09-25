//
//  NavTextStyle.swift
//  PokeFinder
//
//  Created by Shubroto Shuvo on 8/14/21.
//

import Foundation
import SwiftUI

struct NavTextStlye: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title3)
            .foregroundColor(Color(Colors.white))
    }
}

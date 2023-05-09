//
//  ImageOverlay.swift
//  UserDummyApi
//
//  Created by Terhi Järvinen on 9.5.2023.
//

import Foundation
import SwiftUI

struct ImageOverlay: View {
    var body: some View {
        ZStack {
            Text("Find your users")
                .font(.callout)
                .padding(6)
                .foregroundColor(.white)
        }.background(Color.black)
        .opacity(0.8)
        .cornerRadius(10.0)
        .padding(6)
    }
}

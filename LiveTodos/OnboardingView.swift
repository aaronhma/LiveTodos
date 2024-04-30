//
//  OnboardingView.swift
//  LiveTodos
//
//  Created by Aaron Ma on 4/29/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var page = 1

    var body: some View {
        VStack {
            Text("Hello.")

            Button {} label: {
                Text("Continue")
                    .background(.blue)
                    .foregroundStyle(.white)
            }
        }
    }
}

#Preview {
    OnboardingView()
}

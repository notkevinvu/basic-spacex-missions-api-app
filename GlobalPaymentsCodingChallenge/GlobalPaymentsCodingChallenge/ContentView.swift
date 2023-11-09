//
//  ContentView.swift
//  GlobalPaymentsCodingChallenge
//
//  Created by Kevin Vu on 11/9/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = LaunchListViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .task {
            await viewModel.getLaunches()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

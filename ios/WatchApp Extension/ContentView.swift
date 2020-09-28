//
//  ContentView.swift
//  WatchApp Extension
//
//  Created by Adam Kvasnička on 27/09/2020.
//

import SwiftUI

struct ContentView: View {
    private var onIncrement: () -> ()
    @EnvironmentObject var appState: AppState
    
    init(onIncrement: @escaping () -> ()) {
        self.onIncrement = onIncrement
    }
    
    var body: some View {
        VStack {
            Button(action: {
                            self.onIncrement()
                        }){
                Text("Counter: \(appState.counter)")
                    .padding()
                    .foregroundColor(Color.white)
            }
        }
    }
}

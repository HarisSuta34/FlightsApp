//
//  ContentView.swift
//  FlightsApp
//
//  Created by Haris Suta on 21. 7. 2025..
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color(red: 36/255, green: 97/255, blue: 223/255)
                .ignoresSafeArea(.all)

            Image("Untitled design-2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
            
        }
    }
}

// Preview Provider za prikaz u Xcode-u
#Preview {
    ContentView()
}

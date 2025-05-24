//  ContentView.swift
//  Whisker Wonderland
//  Created by Fernando Cardona on 5/22/25.

import SwiftUI

struct ContentView: View {
    @StateObject private var catStore = CatStore()
    
    var body: some View {
        TabView {
            CatListView()
                .environmentObject(catStore)
                .tabItem {
                    Label("Cats", systemImage: "cat")
                }
            
            AboutUsView()
                .tabItem {
                    Label("About Us", systemImage: "info.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}

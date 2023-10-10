//
//  ContentView.swift
//  WordScramble
//
//  Created by aydin salman on 10/10/23.
//

import SwiftUI

struct ContentView: View {
    let people = ["Finn", "Leia", "Luke", "Rey"]
    var body: some View {
        List {
            Section {
                Text("a")
            }
            
            ForEach(2..<5){
                Text("\($0)")
            }
        }
        List(0..<2){
            Text("\($0)")
        }
        List(people, id: \.self){
            Text("\($0)")
        }
        
    }
}

#Preview {
    ContentView()
}

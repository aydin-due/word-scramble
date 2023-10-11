//
//  ContentView.swift
//  WordScramble
//
//  Created by aydin salman on 10/10/23.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    func addWord(){
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        withAnimation { usedWords.insert(answer, at: 0) }
        newWord = ""
    }
    
    var body: some View {
        NavigationView{
            List {
                Section {
                    TextField("enter your word: ", text: $newWord)
                        .textInputAutocapitalization(.never)
                        
                }
                Section {
                    ForEach(usedWords, id: \.self) { word in
                        HStack {
                            Image(systemName: "\(word.count).circle")
                            Text(word)
                        }
                    }
                }
            }
            .navigationTitle(rootWord)
            .onSubmit(addWord)
        }
    }
}

#Preview {
    ContentView()
}

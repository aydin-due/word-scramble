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
    @State private var errorTitle = ""
    @State private var errorMsg = ""
    @State private var showingError = false
    @State private var score = 0
    
    func start() {
        // find file url
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let words = startWords.components(separatedBy: "\n")
                rootWord = words.randomElement() ?? "si"
                return
                
            }
        }
        fatalError("something went wrong ://")
    }
    
    func restart(){
        start()
        usedWords = []
        score = 0
    }
    
    func addWord(){
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard answer.count > 0 else { return }
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }

        guard isLegal(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard isNotShort(word: answer) else {
            wordError(title: "Short word", message: "Must be longer than 2 characters")
            return
        }
        
        guard isNotRoot(word: answer) else {
            wordError(title: "Not a guess", message: "Start word doesn't count as a guess")
            return
        }
        
        score += answer.count
        withAnimation { usedWords.insert(answer, at: 0) }
        newWord = ""
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isLegal(word: String) -> Bool {
        var temp = rootWord
        for letter in word {
            if let pos = temp.firstIndex(of: letter) {
                temp.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound
    }
    
    func isNotShort(word: String) -> Bool {
        return word.count >= 3
    }
    
    func isNotRoot(word: String) -> Bool {
        return word != rootWord
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMsg = message
        showingError = true
    }
    
    var body: some View {
        NavigationView{
            List {
                Section {
                    TextField("enter your word: ", text: $newWord)
                        .textInputAutocapitalization(.never)
                        
                }
                Section {
                    Text("score: \(score)")
                        .font(.headline)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
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
            .onAppear(perform: start)
            .alert(errorTitle, isPresented: $showingError) {
                Button("ok", role: .cancel) {}
            } message: {
                Text(errorMsg)
            }
            .toolbar {
                Button("restart", action: restart)
            }
        }
        
    }
}

#Preview {
    ContentView()
}

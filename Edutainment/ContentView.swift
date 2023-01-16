//
//  ContentView.swift
//  Edutainment
//
//  Created by Aktilek Ishanov on 10.01.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var isActive = false
    @State private var rangeFrom = 2
    @State private var rangeTo = 12
    @State private var questionAmounts = [5, 10, 15]
    @State private var questionAmount = 5
    @State private var numbers = [Int]()
    @State private var answers = [Int]()
    @State private var results = [Int]()
    @State private var score = 0
    @State private var showingScore = false
    @State private var showingSubmitAnswers = true
    @FocusState private var answerIsFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                if !isActive {
                    List {
                        Section {
                            Stepper("From: \(rangeFrom)", value: $rangeFrom, in: 2...11, step: 1)
                            Stepper("To: \(rangeTo)", value: $rangeTo, in: (rangeFrom + 1)...12, step: 1)
                        } header: {
                            Text("Multiplication range")
                        }
                        
                        Section {
                            Picker("Question amount", selection: $questionAmount) {
                                ForEach(questionAmounts, id: \.self){
                                    Text("\($0)")
                                }
                            }
                            .pickerStyle(.segmented)
                        } header: {
                            Text("Question amount")
                        }

                        HStack {
                            Spacer()
                            withAnimation {
                                Button("Start Game", action: startGame)
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                            Spacer()
                        }
                    }
                }
                else {
                    List{
                        Section {
                            ForEach(0..<questionAmount) { i in
                                HStack {
                                    Text("\(numbers[2 * i])  x  \(numbers[2 * i + 1])  =")
                                    TextField("Your answer", value: $answers[i], format: .number)
                                        .keyboardType(.numberPad)
                                        .focused($answerIsFocused)
                                    
                                    if showingScore {
                                        Text(results[i] == 1 ? "Correct" : "Wrong")
                                            .foregroundColor( results[i] == 1 ? .green : .red)
                                    }
                                }
                            }
                        } header: {
                            Text("Calculate the following")
                        }
                        
                        if showingScore {
                            Section {
                                Text("Score: \(score) / \(questionAmount)")
                            } header: {
                                Text("Results")
                            }
                        }
                        
                        if showingSubmitAnswers {
                            HStack {
                                Spacer()
                                Button("Submit", action: submitAnswers)
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                Spacer()
                            }
                        }
                        
                        HStack {
                            Spacer()
                            Button("Restart", action: startGame)
                                .font(.headline)
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done"){
                                answerIsFocused = false
                            }
                        }
                    }
                }
            }
            .navigationTitle("Edutainment")
        }
    }
    
    func startGame() {
        numbers = [Int]()
        results = [Int]()
        answers = [Int]()
        
        isActive.toggle()
        for _ in 0..<(questionAmount * 2) {
            numbers.append(Int.random(in: rangeFrom...rangeTo))
            results.append(0)
        }
        
        for _ in 0..<questionAmount {
            answers.append(0)
        }
        
        score = 0
        showingSubmitAnswers = true
        showingScore = false
    }
    
    func submitAnswers() {
        for i in 0..<questionAmount {
            if numbers[ 2 * i ] * numbers[ 2 * i + 1 ] == answers[i] {
                score += 1
                results[i] = 1
            }
        }
        showingSubmitAnswers = false
        showingScore = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

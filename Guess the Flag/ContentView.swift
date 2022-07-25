//
//  ContentView.swift
//  Guess the Flag
//
//  Created by Maciej on 24/07/2022.
//

import SwiftUI

struct FlagImage: View {
    var countries: [String]
    var number: Int
    
    var body: some View {
        Image(countries[number])
            .renderingMode(.original)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(radius: 5)
    }
}

struct LargeBlueFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 32))
            .foregroundStyle(.blue)
    }
}

extension View {
    func largeBlueFont() -> some View {
        modifier(LargeBlueFont())
    }
}

struct ContentView: View {
    @State private var isGameFinished = false
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var questionNumber = 1
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var countries = [
        "Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria",
        "Poland", "Russia", "Spain", "UK", "US"
    ].shuffled()
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [
                Color("Gradient1"), Color("Gradient2")
            ]), startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            
            VStack {
                Spacer()

                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
    
                Spacer()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(countries: countries, number: number)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.white.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()

                VStack {
                    Text("Question \(questionNumber)/8")
                        .font(.subheadline.weight(.heavy))
                    Text("Score: \(userScore)")
                }
                .foregroundColor(.white)
                .font(.title.bold())
                
                Spacer()
                
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            scoreTitle == "Correct!" ? Text("You get a point.") : Text("You lose a point.")
        }
        .alert("Game finished", isPresented: $isGameFinished) {
            Button("Restart", action: finishGame)
        } message: {
            userScore == 8 ? Text("Pefect! You got the maximum score") : Text("You ended with \(userScore) score.")
        }
    }
    
    func flagTapped(_ number: Int) {
        scoreTitle = { number == correctAnswer ? "Correct!" : "Wrong, it's \(countries[number])." }()
        
        if questionNumber != 8 {
                userScore = { number == correctAnswer ? userScore + 1 : userScore - 1 }()
        } else {
            if userScore == 7 { userScore += 1}
            isGameFinished = true
            showingScore = false
            return
        }
        
        questionNumber += 1
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func finishGame() {
        userScore = 0
        questionNumber = 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        isGameFinished = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

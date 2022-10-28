//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by john martin on 9/15/22.
//

import SwiftUI

enum GAME_OPTIONS: CaseIterable {
    case rock
    case paper
    case scissors
    
    var description : String {
        switch self {
        case .rock: return "🪨"
        case .paper: return "🗒️"
        case .scissors: return "✂️"
        }
    }
}

enum GAME_STRATEGY: CaseIterable {
    case win
    case lose
    
    var description : String {
        switch self {
        case .win: return "Win"
        case .lose: return "Lose"
        }
    }
}

let GAME_OPTION_MAP = [
    GAME_OPTIONS.paper: [
        GAME_STRATEGY.win: GAME_OPTIONS.scissors,
        GAME_STRATEGY.lose: GAME_OPTIONS.rock
    ],
    GAME_OPTIONS.rock: [
        GAME_STRATEGY.win: GAME_OPTIONS.paper,
        GAME_STRATEGY.lose: GAME_OPTIONS.scissors
    ],
    GAME_OPTIONS.scissors: [
        GAME_STRATEGY.win: GAME_OPTIONS.rock,
        GAME_STRATEGY.lose: GAME_OPTIONS.paper
    ]
]


struct GameButton: View {
    
    var text = ""
    var action: () -> Void
    
    var body: some View {
        
        Button(text, action: action)
        .padding(10)
        .font(.system(size: 36))
        .background(.thickMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct ContentView: View {
    
    @State private var score = 0
    @State private var currentOpponent: GAME_OPTIONS = GAME_OPTIONS.allCases.randomElement()!
    @State private var currentStrategy: GAME_STRATEGY = GAME_STRATEGY.allCases.randomElement()!
    @State private var questionsAnswered = 0
    @State private var gameIsOver = false
    
    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [.green, .blue]), startPoint: .bottom, endPoint: .top)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                VStack {
                    Text("Score: \(score)")
                        .font(.system(size: 26))
                }
                .padding(10)
                .frame(maxWidth: .infinity)
                
                .background(.thinMaterial)
                
                Spacer()
                Spacer()
                
                VStack {
                    Text(currentStrategy.description)
                        .font(.system(size: 64))
                    
                    Text(currentOpponent.description)
                }
                .padding(15)
                .font(.system(size: 64))
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
                Spacer()
                
                HStack {
                    Spacer()
                    Spacer()
                    GameButton(text: "🪨") {
                        onSelectionMade(GAME_OPTIONS.rock)
                    }
                    Spacer()
                    GameButton(text: "🗒️") {
                        onSelectionMade(GAME_OPTIONS.paper)
                    }
                    Spacer()
                    GameButton(text: "✂️") {
                        onSelectionMade(GAME_OPTIONS.scissors)
                    }
                    Spacer()
                    Spacer()
                }
                
                Spacer()
            }
        }.alert("Your score \(score)", isPresented: $gameIsOver) {
            Button("Next Game", action: resetGame)
        }
    }
    
    func onSelectionMade(_ selection: GAME_OPTIONS) {
                
        if GAME_OPTION_MAP[currentOpponent]?[currentStrategy] == selection {
            print("Correct")
            score = score + 1
        } else {
            print("Nope")
            score = score - 1
        }
        
        questionsAnswered = questionsAnswered + 1
        
        if questionsAnswered == 10 {
            gameIsOver = true
        }
        
        startNewGame()
    }
    
    func startNewGame() {
        currentOpponent = GAME_OPTIONS.allCases.randomElement()!
        currentStrategy = GAME_STRATEGY.allCases.randomElement()!
    }
    
    func resetGame () {
        gameIsOver = false
        score = 0
        questionsAnswered = 0
        startNewGame()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

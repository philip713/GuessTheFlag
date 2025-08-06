//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Philip Janzel Paradeza on 2022-08-17.
//

import SwiftUI

struct FlagImage : ViewModifier{
    @State private var rotation = 0.0
    var action: () -> Void = {}
    func body(content: Content) -> some View {
        content
            .clipShape(Capsule())
            .shadow(radius: 5)
            .rotation3DEffect(.degrees(rotation), axis: (x: 0.0, y: 1.0, z: 0.0))
            .onTapGesture {
                withAnimation{
                    rotation += 360.0
                    action()
                }
            }
    }
}
struct CustomTitle : ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.bold))
            .foregroundColor(.white)
    }
}

extension View{
    func customTitle() -> some View{
        modifier(CustomTitle())
    }
}
struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    let labels = [
        "Estonia": "Flag with three horizontal stripes. Top stripe blue, middle stripe black, bottom stripe white.",
        "France": "Flag with three vertical stripes. Left stripe blue, middle stripe white, right stripe red.",
        "Germany": "Flag with three horizontal stripes. Top stripe black, middle stripe red, bottom stripe gold.",
        "Ireland": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe orange.",
        "Italy": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe red.",
        "Nigeria": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe green.",
        "Poland": "Flag with two horizontal stripes. Top stripe white, bottom stripe red.",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red.",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background.",
        "Ukraine": "Flag with two horizontal stripes. Top stripe blue, bottom stripe yellow.",
        "US": "Flag with many red and white stripes, with white stars on a blue background in the top-left corner."
    ]
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingAlert = false
    @State private var showingScore = false
    @State private var isFinished = false
    @State private var scoreTitle = ""
    @State private var score = 0
    @State private var questionCounter = 1
    @State private var pickedFlag = -1
    @State private var notPicked = false
    var body: some View {
        ZStack{
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                Text("Guess the Flag")
                    .customTitle()
                VStack (spacing: 15){
                    VStack{
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3){ number in
                        Button{
                            pickedFlag = number
                            //flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .modifier(FlagImage(){
                                    flagTapped(number)
                                    
                                })
                                .opacity((notPicked && (number != pickedFlag)) ? 0.25 : 1)
                                .accessibilityLabel(labels[countries[number], default: "unknown flag"])
                        }
                         
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .font(.title.bold())
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            
        }
        .alert(scoreTitle, isPresented: $showingScore){
            Button("Continue", action: askQuestion)
        }
        .alert("End of the Game", isPresented: $isFinished){
            Button("Restart the Game", action: restart)
        }message: {
            Text("Your Final Score is \(score)")
        }
        .ignoresSafeArea()
    }
    
    func flagTapped(_ number : Int){
        withAnimation{
            notPicked = true
            pickedFlag = number
        }
        if (number == correctAnswer){
            scoreTitle = "Correct"
            score += 1
        }
        else{
            scoreTitle = "Wrong that is the flag of " + countries[number]
            
        }
        showingScore = true
    }
    func askQuestion(){
        pickedFlag = -1
        notPicked = false
        if(questionCounter >= 8){
            isFinished = true
        }
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionCounter += 1
    }
    func restart(){
        questionCounter = 1
        score = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

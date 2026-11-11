//
//  ChessBoard.swift
//  ChessOpener
//
//  Created by Christopher W. Kenny on 11/3/26.
//

import ChessboardKit
import SwiftUI


struct ChessGameView: View{
    //Create instance of game for ViewModel
    @State private var vm = ChessViewModel()
    @State private var hasStarted = false
    
    var body: some View{
        VStack(spacing: 20){
            //Displays opening being played, starts with 'Your Move!'
            Text(vm.openingName ?? "Your Move!")
                .font(.title.bold())
                .multilineTextAlignment(.center)
                .background(Rectangle().fill(Color(red: 0.6, green: 0.8, blue: 1.0)))
            
            
            //MARK: The Chessboard
            Chessboard(chessboardModel: vm.boardModel)
                .onMove {move, isLegal, from, to, lan, promotionPiece in
                    print("Move: Fen: \(vm.boardModel.fen) - Lan: \(lan)")
                    
                    if !isLegal{
                        print("Illegal move: \(lan)")
                        return
                    }
                    vm.userMoved(lan: lan)
                }
                .aspectRatio(1, contentMode: .fit)
                .padding(.horizontal)
            
            if vm.isThinking {
                ProgressView("Computer Thinking")
            }
            if let msg = vm.statusMessage{
                Text(msg).foregroundStyle(.red)
            }
            MoveListView(moves: vm.moveHistory)
            
            //Allow user to pick side (white or black) to start a new 'game'
            HStack{
                Button("Play White"){
                    vm.startGame(as: .white)
                }
                Button("Play Black"){
                    vm.startGame(as: .black)
                }
            }.buttonStyle(.bordered) //HStack
            Button("Reset Board"){
                vm.resetGame()
            } .buttonStyle(.borderedProminent)
        }//VStack
        .padding(.vertical)
        .task{
            guard !hasStarted
                else{
                return
            }
            hasStarted = true
            vm.startGame(as: .white)
        }
    }
}

//MARK: Move List
struct MoveListView: View{
    let moves: [MoveRecord]
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing:10){
                    ForEach(moves) {m in
                        HStack(spacing: 5){
                            if m.isWhiteMove {
                                Text("\(m.moveNumber).")
                            }
                            Text(m.san).bold(m.isUser)
                        }
                        .id(m.id)
                    }
                }
                .padding(.horizontal)
            }
            //scroll list to newest move
            .onChange(of: moves.count){
                if let last = moves.last {
                    withAnimation {proxy.scrollTo(last.id, anchor: .trailing)}
                }
            }
        }
    }
}//MoveListView struct

#Preview{
    ChessGameView()
}

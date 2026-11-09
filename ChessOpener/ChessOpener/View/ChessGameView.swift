//
//  ChessBoard.swift
//  ChessOpener
//
//  Created by Christopher W. Kenny on 11/3/26.
//

import ChessboardKit
import SwiftUI


struct ChessGameView: View{
    //Create instance of ObservableObject (view model) for the game
    @State private var vm = ChessViewModel()
    @State private var hasStarted = false
    
    var body: some View{
        VStack(spacing: 20){
            //Display chess opening from Lichess on top of screen
            Text(vm.openingName ?? "Your Move!")
                .font(.title.bold())
                .multilineTextAlignment(.center)
            
            
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
                .aspectRatio(contentMode: .fit)
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
            }//HStack
            .buttonStyle(style: .bordered)
        }//VStack
        .padding(.vertical)
        .task{
            guard hasStarted
                else{
                return
            }
            hasStarted = true
            vm.startGame(as: PlayerSide?)
        }
    }
}

//MARK: Move List
struct MoveListView: View{
    let moves = [MoveRecord]
    
    var body: some View {
        ScrollViewProxy { proxy in
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
            //Ensure validation through ChessKit using .onchange property
            .onChange(of: moves.count){
                if let last = moves.last {
                    withAnimation {proxy.scrollTo(last.id)}
                }
            }
        }
        .frame(width: 20, height: 20)
    }
}//MoveListView struct

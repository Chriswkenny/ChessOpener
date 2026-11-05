//
//  ChessBoard.swift
//  ChessOpener
//
//  Created by Christopher W. Kenny on 11/3/26.
//

import ChessKit
import ChessboardKit
import SwiftUI


struct ChessBoard: View{
    //Create instance of ObservableObject (view model) for the game
    @StateObject private var vm = ChessViewModel()
    
    var body: some View{
        VStack(spacing: 10){
            ChessBoard(chessboardModel: $vm.boardModel)
                .onMove{
                    move, isLegal, from, to, lan, promotionPiece in
                    print("Move: Fen: \(chessboardModel.fen) - Lan: \(lan)")
                    
                    if !isLegal{
                        print("Illegal move: \(lan)")
                        return
                    }
                    vm.userMoved(san: move, lan: lan)
                    
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(vm.record.moves){
                                Text($0.san)
                            }
                        }
                    }
                    Button("Reset", action: vm.start)
                }
        }
    }
    
}

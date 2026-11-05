//
//  ChessBoard.swift
//  ChessOpener
//
//  Created by Christopher W. Kenny on 11/3/26.
//

import ChessKit
import ChessboardKit
import SwiftUI


struct ChessGameView: View{
    //Create instance of ObservableObject (view model) for the game
    @StateObject private var vm = ChessViewModel()
    
    var body: some View{
        VStack(spacing: 10){
            Chessboard(chessboardModel: vm.boardModel)
                .onMove {_, isLegal, from, to, lan, promotionPiece in
                    print("Move: Fen: \(vm.boardModel.fen) - Lan: \(lan)")
                    
                    if !isLegal{
                        print("Illegal move: \(lan)")
                        return
                    }
                    vm.userMoved(lan: lan)
                }
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(vm.record.moves){
                                moveRecord in
                                Text(moveRecord.lan)
                            }
                        }
                    }
                    Button("Reset", action: vm.start)
                }
        }
}

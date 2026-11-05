//
//  ChessViewModel.swift
//  
//
//  Created by Christopher W. Kenny on 11/5/26.
//
import Foundation
import ChessKit
import ChessboardKit
import SwiftUI
public import Combine

@MainActor
final class ChessViewModel: ObservableObject {
    //Properties of
    @Published var record = GameRecord()
    @Published var boardModel = ChessboardModel()
    
    init(){
        let startPosition = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1" //initial board starting position
        
        self.boardModel = ChessboardModel(
            fen: startPosition,
            perspective: .white,
            colorScheme: .light,
            allowOpponentMove: false,
            
            highlightLegalMoves: true
        )
        //Initialize GameRecord
        self.record = GameRecord()
    }
    //Starts at initial chess position
    func start(){
        let startPosition = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
        boardModel.setFen(startPosition)
    
    }
    
    //Updates chess board based on user moves, updates on board
    func userMoved(lan: String){
        record.moves.append(PlayedMove(lan: lan, fenAfter: boardModel.fen))
    }
    
    //reset the board to starting position
    func reset(){
        record = GameRecord()
        boardModel.setFen("rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2")
    }
}
  
   
  

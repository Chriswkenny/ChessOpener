//
//  ChessViewModel.swift
//  
//
//  Created by Christopher W. Kenny on 11/5/26.
//
import Foundation
import ChessKit
import ChessboardKit
public import Combine

@MainActor
final class ChessViewModel: ObservableObject {
    @Published var record = GameRecord()
    let boardModel = ChessboardModel(
        fen:
            "rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2",//initial board starting position
        perspective: .white, //Board perspective (white for now)
        colorScheme: .light //Color scheme
        )
    //Updates chess board based on user moves, updates on board
    func userMoved(san: String, lan: String){
        record.moves.append(PlayedMove(lan: lan, san: san))
    }
    //reset the board to starting position
    func reset(){
        record = GameRecord()
        boardModel.setFen("rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2")
    }
}

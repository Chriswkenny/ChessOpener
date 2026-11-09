//
//  ChessEngine.swift
//  ChessOpener
//
//  Created by Christopher W. Kenny on 11/6/26.
//
import ChessKit


//Class that handles all of the chess logic utilizing ChessKit
final class ChessEngine{
    //Board is set to a new game
    private var board = Board(position: .standard)
    //current position of the board
    var fen: String {FENParser.convert(position: board.position)}
    //Whose turn it is
    var sidetoMove: Piece.color {
        board.position.sidetoMove
    }
    //Apply the users move
    func applyUserMove(from: String, to: String) -> String? {
        let start = Square(from)
        let end = Square(to)
        guard board.canMove(pieceAt: start, to: end)
            else{ return nil }
        guard let move = board.move(pieceAt: start, to: end)
                else{ return nil }
        return move.san
    }
    //Apply computer move
    func applyComputerMove(san: String) -> String? {
        guard let parsed = SANParser.parse(move: san, in: board.position)
            else{ return nil }
        guard let move = board.move(pieceAt: parsed.start, to: parsed.end)
                else{ return nil }
        return move.san
    }
    
    func reset(){
        board = Board(position: .standard)
    }
}

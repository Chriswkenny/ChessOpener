//
//  ChessEngine.swift
//  ChessOpener
//
//  Created by Christopher W. Kenny on 11/6/26.
//
import ChessKit


//Class that handles all of the chess logic utilizing ChessKit
final class ChessEngine{
    
    //Set the starting fen (will never change)
    static let startFen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"
    
    private var board = Board()
    
    private var game: Game = ChessEngine.makeGame(fen: ChessEngine.startFen)
    
    private static func makeGame(fen: String) -> Game {
        Game(position: FenSerialization.default.deserialize(fen: fen))
        }
    
    var fen: String{
        FenSerialization.default.serialize(position: game.position)
    }
    
    //Whose turn it is
    var sidetoMove: PieceColor { game.position.state.turn }
    var isWhiteMove: Bool { sidetoMove == .white } //White always starts
    
    //Apply the users move LAN: (i.e e2e4), SAN: e4, nil if rejected
    func applyUserMove(lan: String) -> String? {
        guard lan.count >= 4 else { return nil }
        
        let san = SanSerialization.default.san(for: Move(string: lan), in: game)
        
        guard apply(uci: lan) else { return nil }
        
        return san.isEmpty ? lan : san //return lan if san is empty
    }
    
    //Apply computer move
    func applyComputerMove(uci: String, san: String) -> String? {
        guard uci.count >= 4 else { return nil }
        let lan = fixedForCastling(uci: uci, san: san)
        return apply(uci: lan) ? lan : san
    }
    
    //apply function
    private func apply(uci: String) -> Bool {
        let before = fen
        game.make(move: uci)
        return fen != before
    }
    
    //Function to account for Castling (from documentation)
    private func fixedForCastling(uci: String, san: String) -> String {
        if san.hasPrefix("O-O-O"){
            return isWhiteMove ? "e1c1" : "e8c8"
        }
        if san.hasPrefix("O-O"){
            return isWhiteMove ? "e1g1" : "e8g8"
        }
        return uci
    }
    
    //Reset the board
    func reset(){
        game = ChessEngine.makeGame(fen: ChessEngine.startFen)
    }
}

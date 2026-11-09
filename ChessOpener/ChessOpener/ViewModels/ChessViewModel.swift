//
//  ChessViewModel.swift
//  
//
//  Created by Christopher W. Kenny on 11/5/26.
//
import SwiftUI
import ChessboardKit

@MainActor
@Observable
class ChessViewModel{
    
    //Views Being Rendered
    private var moveHistory: [MoveRecord] = []
    private var isThinking = false
    private var openingName: String? //optional
    private var side: PlayerSide = .white //default white for now
    var statusMessage: String? //verify the user is playing the opening
    
    //Display chessboard using ChessboardKit model
    let boardModel = ChessboardModel(fen: FEN.standard, perspective: .white, colorScheme: .blue)
    
    //call to ChessEngine class for chess logic
    private let engine = ChessEngine()
    private let service = LichessService()
    
    //MARK: Start Chess Game
    func startGame(as newSide: PlayerSide) {
        side = newSide
        engine.reset()
        moveHistory()
        openingName = nil
        statusMessage = nil
        isThinking = false //computer to move verification
        
        boardModel.perspective = (newSide == .white) ? .white : .black
        boardModel.setFen(engine.fen)
        
        //If the user selects black, computer must make first move
        if newSide == .black {
            requestComputerMove()
        }
    }
    
    //MARK: User Inputs, Called from ChessboardKit's onMove property
    func userDidMove(from: String, to: String){
        guard isThinking
            else{
                ChessboardModel.setFen("New FEN String")
                return
        }
    }
    //MARK: Async call to computer to respond to User's move
    private func requestComputerMove(){
        //Force stop of task if Lichess connection drops
        replyTask?.cancel()
        isThinking = true
        let fen = engine.fen
        
        replyTask = Task {[weak self] in
        guard let self
                else{
            return
        }
        
            do {
                let result = try await self.service.nextMove(fen: fen)
                
                //Ensure the board was not reset before making call
                try Task.checkCancellation()
                
                if let opening = result.opening {
                    self.openingName = opening.name
                }
                
                guard let move = result.move
                    else{
                    //If user makes "incorrect move" in opening sequence
                    self.statusMessage = "Diverged Outside of Book Opening, Try Again!"
                    self.isThinking = false //computer wont respond
                    return
                }
                guard let san = self.engine.applyComputerMove(san: move.san)
                        else{
                    //If engine fails to find correct move in sequence
                    self.statusMessage = "Could not make move at \(move.san)"
                    self.isThinking = false
                    return
                }
                self.record(san: san, isUser = false)
                self.boardModel.setFen(self.engine.fen, animated: true)
                self.isThinking = false
            }
        }
    }
    private func record(san: String, isUser: Bool){
        moveHistory.append(MoveRecord(ply: moveHistory.count + 1, san: san, isUser: isUser))
    }
}
  
   
  

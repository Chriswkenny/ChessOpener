//
//  ChessViewModel.swift
//  
//
//  Created by Christopher W. Kenny on 11/5/26.
//
import SwiftUI
import ChessboardKit
import ChessKit

@MainActor
@Observable
final class ChessViewModel {
    
    //Views Being Rendered
    //private(set) learned from ChessKit package
    private(set) var moveHistory: [MoveRecord] = []
    private(set) var isThinking = false
    private(set) var openingName: String? //optional
    private(set) var side: PlayerSide = .white //default white for now
    var statusMessage: String? //verify the user is playing the opening
    
    //Display chessboard using ChessboardKit model
    let boardModel = ChessboardModel(fen: ChessEngine.startFen, perspective: .white, colorScheme: .blue)
    
    //call to ChessEngine class for chess logic
    private let engine = ChessEngine()
    private let service = LichessService()
    private var replyTask: Task<Void, Never>?
    
    //MARK: Start Chess Game
    func startGame(as newSide: PlayerSide) {
        replyTask?.cancel() //Stop last games process
        side = newSide
        engine.reset()      //Reset board
        moveHistory = []
        openingName = nil
        statusMessage = nil
        isThinking = false   //computer to move verification
        
        boardModel.perspective = (newSide == .white) ? .white : .black
        //will be used to update board with user/computer moves
        //Idea gotten from documentation
        syncBoard()
        
        //If the user selects black, computer must make first move
        if newSide == .black {
            requestComputerMove()
        }
    }
    
    //MARK: User Inputs, Called from ChessboardKit's onMove property
    func userMoved(lan: String){
        guard !isThinking
            else{
                syncBoard()
                return
        }
        
        
        guard (engine.sidetoMove == .white) == (side == .white) else {
            syncBoard()
            return
        }
        
        guard let san = engine.applyUserMove(lan: lan) else{
            //this needs better functionality
            statusMessage = "Illegal Move. Try again!" //need to add a way to reset the board back a position
            syncBoard()
            return
        }
        statusMessage = nil
        record(san: san, isUser: true)
        syncBoard()
        requestComputerMove()
    }
    
    //MARK: Async call to computer to respond to User's move
    private func requestComputerMove(){
        //Force stop of task if Lichess connection drops
        replyTask?.cancel()
        isThinking = true //computer "thinks" of what move to respond with
        let fen = engine.fen //current board position
        
        replyTask = Task {[weak self] in
            guard let self else{ return }
        
            do {
                let result = try await self.service.nextMove(fen: fen)
                
                //A pause to give the user time to understand the move, Lichess responds instantly
                try await Task.sleep(for: .milliseconds(1000))
                
                //Ensure the board was not reset before making call
                try Task.checkCancellation()
                
                if let opening = result.opening {
                    self.openingName = opening.name
                }
                
                guard let move = result.move
                    else{
                    //If user makes "incorrect move" in opening sequence
                    //This needs stronger implementation.
                    self.statusMessage = "Diverged Outside of Book Opening, Try Again!"
                    self.isThinking = false //computer wont respond
                    return
                }
                guard let appliedLan = self.engine.applyComputerMove(uci: move.uci, san: move.san)
                        else{
                    //If engine fails to find correct move in sequence
                    self.statusMessage = "Could not make move at \(move.san)"
                    self.isThinking = false
                    return
                }
                self.record(san: move.san, isUser: false)
                self.syncBoard(lan: appliedLan)
                self.isThinking = false
            }catch is CancellationError{
                //If a new game is started while waiting for input
            }catch{
                self.statusMessage = error.localizedDescription
                self.isThinking = false
            }
        }
    }
    //MARK: Other Functions
    //Pushes the user/computer moves to the board
    private func syncBoard(lan: String? = nil){
        boardModel.setFen(engine.fen, lan: lan)
    }
    
    //Resets Board
    func resetGame() {
        startGame(as: side)
    }
    
    //Displays the sequence of moves at the bottom of the board
    private func record(san: String, isUser: Bool){
        moveHistory.append(MoveRecord(move: moveHistory.count + 1, san: san, isUser: isUser))
    }
}
  
   
  

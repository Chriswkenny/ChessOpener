//
//  GameRecord.swift
//  
//
//  Created by Christopher W. Kenny on 11/5/26.
//
import Foundation
import ChessKit
import ChessboardKit

//Struct to hold record of the opening being played by user
struct GameRecord {
    var startFEN: String = "rnbqkbnr/pp1ppppp/8/2p5/4P3/5N2/PPPP1PPP/RNBQKB1R b KQkq - 1 2"
    var moves: [PlayedMove] = []
}

//Struct for computer to read move made by user and respond
struct PlayedMove: Identifiable {
    let id = UUID()
    let lan = String.self //i.e {c2c4}
    let san: String //i.e {e4}
}

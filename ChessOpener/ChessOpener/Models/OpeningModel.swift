//
//  OpeningResponse.swift
//  ChessOpener
//
//  Created by Christopher W. Kenny on 11/5/26.
//

import Foundation

struct ExplorerResponse: Codable {
    let moves: [ExplorerMove]
    let opening: OpeningInfo?
}

struct ExplorerMove: Codable {
    let uci: String
    let san: String
    let white: Int
    let black: Int
    let draws: Int
    
    var totalGames: Int {
        white + draws + black
    }
}

struct OpeningInfo: Codable {
    let eco: String //i.e "A20"
    let name: String //i.e "English Opening"
}

//MARK: Cases for User to Select Side They Want To Play
enum PlayerSide{
    case white
    case black
}

struct MoveRecord: Identifiable {
    let id = UUID()
    let move: Int //used to count moves in the current game
    let san: String
    let isUser: Bool
    
    var moveNumber: Int { (move + 1) / 2}
    var isWhiteMove: Bool { move % 2 == 1 } //white always moves first
}



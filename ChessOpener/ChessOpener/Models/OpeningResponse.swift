//
//  OpeningResponse.swift
//  ChessOpener
//
//  Created by Christopher W. Kenny on 11/5/26.
//

import Foundation

//MARK: - Model for Lichess Explorer
struct OpeningResponse: Codable {
    let opening: OpeningDetails?
    let moves: [OpeningMove]
}

struct OpeningDetails: Codable {
    let eco: String //Code of opening
    let name: String //name of opening
}

struct OpeningMove: Codable, Identifiable{
    var id: String { uci }
    let uci = String
    let san: String
    let white: Int
    let draws: Int
    let black: Int
}



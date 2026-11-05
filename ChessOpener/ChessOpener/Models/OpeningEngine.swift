//
//  OpeningEngine.swift
//  ChessOpener
//
//  Created by Christopher W. Kenny on 11/5/26.
//
import Foundation
public import Combine


@MainActor
class OpeningEngine: ObservableObject{
    @Published var currentOpening: String = "Starting Position"
    @Published var recommendedResponse: [OpeningMove] = []
    @Published var isLoading = false
    
    //Function to fetch next move in the sequence from Lichess
    func fetchNextMove(for fen: String) async {
        self.isLoading = true
    }
}

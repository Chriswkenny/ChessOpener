//
//  ChessBoard.swift
//  ChessOpener
//
//  Created by Christopher W. Kenny on 11/3/26.
//

import ChessKit
import ChessboardKit
import SwiftUI

struct ChessBoard: View{
    //Beginning Fen of a chessboard (no moves made)
    @State var chessboardModel = ChessboardModel(fen: " rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR")
    
    var body: some View{
        
    }
    
}

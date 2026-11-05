//
//  LichessAPI.swift
//  ChessOpener
//
//  Created by Christopher W. Kenny on 11/3/26.
//

import Foundation

//Ensure LichessAPI opens correctly
enum LichessAPIError: Error {
    case invalidURL
}

//function to create User Profile
struct LichessUserProfile{
    let id: String
}
//function to fetch LichessAPI
struct LichessAPI{
    private let baseURL = URL(string: "https://lichess.org")
    //Declare API token for user on starting an opening
    private let apiToken: String
    
    //Initialize User Token from Lichess
    init(apiToken: String){
        self.apiToken = apiToken
    }
    
    //Fetch user's authenticated profile
    
    
}

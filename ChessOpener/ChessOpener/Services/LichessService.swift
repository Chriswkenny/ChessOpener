//
//  LichessAPI.swift
//  ChessOpener
//
//  Created by Christopher W. Kenny on 11/3/26.
//

import Foundation

//Ensure LichessAPI opens correctly
enum LichessError: Error {
    case invalidURL
    case invalidStatus
    
    var ErrorDescription: String? {
        switch self {
        case .invalidURL: return "Could not find the request URL"
        case .invalidStatus: return "Lichess returned a non 200 response"
        }
    }
}

//MARK: Computer move selected from Lichess, sent to ChessViewModel
struct ExplorerResult{
    let move: ExplorerMove? //can be nil if user makes out of book move
    let opening: OpeningInfo?
}

//MARK: Lichess Service
    //Need to generate a personal token from Lichess at:
    //lichess.org/account/oauth/token
//From Lichess for allowing users to generate token access, will be implemented later:
//https://lichess.org/account/oauth/token/create?scopes[]=challenge:write&scopes[]=puzzle:read&description=Prefilled+token+example



struct LichessService{
    
    //FOR NOW: ADDED STRUCT TO READ TOKEN FROM JSON TO OMIT FROM ENVIRONMENT
    struct Secret: Decodable { let lichessToken: String }
    
    //Need to generate a token from Lichess to access database
    private var token: String? {
        if let environment = ProcessInfo.processInfo.environment["LICHESS_TOKEN"], !environment.isEmpty{ return environment } //Got API token sequence from Lichess documentation
        guard let url = Bundle.main.url(forResource: "Secret", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let secret = try? JSONDecoder().decode(Secret.self, from: data) else{ return nil }
        return secret.lichessToken.trimmingCharacters(in: .whitespacesAndNewlines) //Token has whitespace after it
                }
    
    //Create a session of the most recent opening
    var session: URLSession = .shared
    
    //Lichess Link
    private let baseURL = "https://explorer.lichess.ovh/lichess"
    
    
    //Async function to find next move computer makes
    func nextMove(fen: String) async throws -> ExplorerResult{
        //Verify url is correct to Lichess
        guard var components = URLComponents(string: baseURL)
                else{
            throw LichessError.invalidURL
        }
        components.queryItems = [
            URLQueryItem(name: "variant", value: "standard"),
            URLQueryItem(name: "fen", value: fen),
            URLQueryItem(name: "moves", value: "4"), //Top 4 move choices
            URLQueryItem(name: "topGames", value: "0"),
            URLQueryItem(name: "recentGames", value: "0")
        ]
        guard let url = components.url
                else{
            throw LichessError.invalidURL
        }

        //Build the request from Lichess
        var request = URLRequest(url: url)
        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    
        
        let(data, response) = try await session.data(for: request)
        //Ensure http response is accepted (200) or throw an error
        if let http = response as? HTTPURLResponse, http.statusCode != 200{
            throw LichessError.invalidStatus
        }
        //Decode JSON to Swift
        let decoded = try JSONDecoder().decode(ExplorerResponse.self, from: data)
        
        //Pick a move the computer makes (SUBJECT TO CHANGE, DOING MOST PLAYED RESPONSE CURRENTLY WITH NO WEIGHT)
        let best = decoded.moves.max {$0.totalGames < $1.totalGames}
        
        return ExplorerResult(move: best, opening: decoded.opening)
    }
}//LichessService



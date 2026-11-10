# ChessOpener
An IOS app built in Swift that teaches users a variety of chess openings

This App utilizes ChessboardKit (v 1.1.2) and ChessKit (v 1.3.7) for handling board rendering and
maintaining the chess logic used in the app.

Unlike most other chess applications on the market, the purpose of this app is not to play full games but to strictly follow
the opening structure of which ever opening the user would like to learn. If the user makes a move that is not expected in the opening sequence,
it sends a prompt to the user that they are diverging from the opening line and should try again. 

The computer responds to user moves utilizing the Lichess opening explorer tool, selecting the response to the users move by the
most popular responses in the respective opening line. The responses are currently based on the four most popular options (due to variations
in all chess opening lines), using Long Algebraic Notation (LAN) for displaying that selected move to the chessboard.

# Structure
Utilizes the MVVM model:

Model: 

OpeningModels - Contains the Explorer Models, establishes variables that are required for the user's perspective (white/black), the opening being played,
                and the computer's response to moves.


ViewModel:

ChessViewModel - Stores the data to be displayed on ChessGameView. Utilizes async to await users move for the computer to send a response based on
                 the most popular responses to the current board structure. 

View:

ChessGameView - Contains the ChessboardKit package which is responsible for displaying the chess board.

Chess Engine:

ChessEngine - Contains the ChessKit package which handles the legality of chess moves.

Services:

LichessService - Handles the calls to the Lichess opening explorer, establishing a connection to the database to be used for the computers response
                 to users input as long as the users move is a correct move in the opening sequence.

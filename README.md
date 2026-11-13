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
                and the computer's response to moves. This file holds the data that is needed for Xcode to know what is being read from the chess/chessboardKit. 
                
Chess Engine:

ChessEngine - Contains the ChessKit package which handles the legality of chess moves. 


ViewModel:

ChessViewModel - Stores the data to be displayed on ChessGameView. Utilizes async to await users move for the computer to send a response based on
                 the most popular responses to the current board structure. Also dynamically updates the header of what opening the user is playing.

View:

ChessGameView - Contains the ChessboardKit package which is responsible for displaying the chess board. It gets the data from the ChessViewModel and the legality of moves is handled by the
                ChessEngine class.


Services:

LichessService - Handles the calls to the Lichess opening explorer, establishing a connection to the database to be used for the computers response
                 to users input as long as the users move is a correct move in the opening sequence. Also responsible for ensuring a valid token from Lichess
                 is found.
                 

# Future Implementations
The application currently requires a Lichess account with no way for users to be able to link their account without access to the code. The plan is to add a button to seamlessly 
add the users Lichess account with a single button click.

There is currently no selection method of what opening the user wishes to learn. While the application dynamically changes the title as the "game" progresses of what line the computer
is playing in response to the users move, I intend on allowing the user to select a specific opening and add a rating (Best, Excellent, Good, incorrect) to the move the user makes versus other possible moves in the sequence
that may be stronger as per the Chess Engine. 

There is currently no way to create an account to store your progress in an opening line (verifying the move is 'legal' in the sequence and if its the best possible move).
Could potentially add a scoring system that saves the users progress in an opening line, eventually "mastering" that specific opening. 

Considering to import Stockfish to create an evaluation bar as seen in other chess applications so the user can get a sense of if the grandfather chess engine (Stockfish) considers the opening strong or weak, depending on what variation of the opening the user is attempting to learn. 

Need to strengthen the "Incorrect move, try again" message as it only displays if the user makes a move that the Lichess API does not see in its sequence (example: playing Knight a3 while in the middle of development in the English). Also need to establish a way for the user to attempt another move if they receive the Incorrect move message. 



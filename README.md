# Slider

## App Store
This project has been accepted by Apple and is available as a free download in the [App Store](https://github.com/tkoinaustin/Slider.git). Please download the app and take it for a spin. I spent time trying to get the gameplay as realistic as possible, and it shows when you start moving the blocks around. Unlike most Klotski style games, Slider allows multiple blocks to move at once, just how the physical game plays.

## About the App
Slider is a Klotski style sliding block game. It is known under a variety of names, including Huarong Dao, Daughter in the box, L'âne rouge and Khun Chang Khun Phaen. The goal is to get the large block out of the puzzle by maneuvering it to the escape area at the bottom of the puzzle. Blocks can only be moved when there is a free space for them to move to, they cannot be removed from the board. 

The main gameboard is where the game is played. The puzzle pieces are laid out according the puzzle level you have selected. When you successfully maneuver the large block out the bottom, you are given the option to replay the game, start the same game over, or go to the next level.

There is a control panel at the bottom. Here you have stats such as how long you have taken on this puzzle and how many moves you have made. You can also move backwards and forwards, replaying the moves using the arrows next to the move counter. The current puzzle is shown in the bottom center and you can reset the puzzle if it gets too frustrating. You can also select from any of the puzzles by clicking the 'puzzles' button.

The puzzles button brings up a list of all the puzzles. If a puzzle has been won, it is underlined in green, tried but failed it is underlined in red, never tried it will be underlined in gray. Also, if you have tried the puzzle the 'History' button will be enabled. Clicking this brings up a list of all attempts made for that puzzle, including the date and number of moves. Selecting any of the previous attempts will bring up a game board and replay the game for you. 

## About the code
Most mobile apps rely on data obtained over the air from various public or private API's, usually in JSON format delivered by a REST service. Games, however, are a different beast. 

This game requires no internet connection to play. The game data is self contained and all gaming history is maintained on the device. As such, the structure of this app is a little different than a typical mobile app.

Normally I would have a full suite of API classes to support data retrival. For this app, not necessary. What I do have are fairly involved model classes that contain the logic for determining legal moves. Remember when I said this game allows multiple blocks to move at once. As far as I know, this is the only one to do so. The reason why is that the logic that goes into that determionation is substantial. But it's a game, so make the gameplay realistic.

## Installation

Clone the project using the 'Clone or Download' link

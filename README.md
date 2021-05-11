# Command-Line Hangman
This project, as [part of the Odin Project's "Ruby Programming" module](https://www.theodinproject.com/paths/full-stack-ruby-on-rails/courses/ruby-programming/lessons/file-i-o-and-serialization-ruby-programming), is an attempt at developing a command-line hangman game under the usual principles of object-oriented programming. In addition, the program features the ability to save and load game progress. Though no sane person would save a game of hangman and come back to it later, this is an exercise in file serialization through Ruby. The game is designed for one person to play against a computer AI in the command-line.

## Technologies
* Ruby 2.7.2

## Launch
To run this project, call it from the home directory of the repository through the command line:

```shell
ruby lib/main.rb
```

Note: the first instance where a hangman game is saved will create a new subdirectory /savegames, with which the game will interface indefinitely once created, even when the program is closed and reopened at a different time.

## To-Do
* **Remove ability to enter erroneous savegame file names, causing the entire program to crash** - currently, the program requires the user to manually enter the filename of the saved game he/she wishes to play. This leaves room for user error, where one wrong character or a wrong file extension can crash the entire program. Priority here is low, as the program was more an exercise in OOP and file serialization than it was in UI/UX.

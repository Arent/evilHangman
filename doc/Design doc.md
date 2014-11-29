h1>evilHangman</h1>
===========
<p>This is just hangman. However, the computer will win(by changing words so it will dodge the guesses of the Human)</p>


<h2>User Interface</h2>
<p>This game has 2 screens</p>

<h3>Main screen:</h3>
<p>This screen will show the made guesses, remaining letters, remaining guesses, a button to the settings, a button for a new game and will contain to popups for when the Human has won or lost the game.</p>


<h3>Flip screen</h3>
<p>This screen will have a button tot the main screen, a slider to adjust the number of guesses the Human has and a slider to adjust the max length of the words</p>

<h2>Classes</h2>

  <h2>mainViewController</h2>
  <blockquote>
    This controller will update the main screen.
    It will have the following methods:
 	- showCorrectGuesses //Updates the view with al the correct guesses ( ie:  _ _ _ A _ _N)
    _ showRemainingGuesses
	
   <h2>settingsViewController</h2>
   <blockquote>
    This controller will update the settings screen.
    It will have the following methods:
    - nummberOfGuesses getter and setter for number of guesses for a new game
    - wordLength getter and setter for the word length for a new game

   <h2>settingsViewController</h2>
   <blockquote>
    This controller handle all the game desicions
     It will have the following methods:
     - gameEnd? method for checking if the game has been ended ( either by winning or no more remaining guesses)
     - validInput Check if user input is valid
     - chooseWordList  This is the method with the evil hangman alogrithem. It will create all the possible equivilance classes with the user input and chooses the largest one.
     - init  This will create a new game with the standard settings or the settings that the user has chosen

<h2>Databases</h2>
p.words (a list of words)

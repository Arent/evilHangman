<h1>evilHangman</h1>
===========
<p>This is just hangman. However, the computer will win(by changing words so it will dodge the guesses of the Human)</p>


<h2>User Interface</h2>
<p>This game has 2 screens</p>

<h3>Main screen:</h3>
<p>This screen will show the made guesses, remaining letters, remaining guesses, a button to the settings, a button for a new game and will contain to popups for when the Human has won or lost the game.</p>


<h3>Flip screen</h3>
<p>This screen will have a button tot the main screen, a slider to adjust the number of guesses the Human has and a slider to adjust the max length of the words</p>


<h2>Classes</h2>

  <h2>MainViewController</h2>
  <blockquote>
 	Updates the main view
	Needs array with guessed letters
	Needs # remaining guesses
	Needs to know if game is won or lost
 </blockquote>

<h2>GameControler</h2>
	Check if input is valid
	Choose subset Words list
	Initialize new game
	Check if Human has won or lost the game
	 

<h2>Databases</h2>
p.words (a list of words)

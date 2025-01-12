#!/bin/bash
# Number guessing game
# Have to add data to database
# Loop while user guesses numbers
# QUERY DATABASE
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# GENERATE RANDOM NUMBER
SECRET_NUMBER=$(( (RANDOM % 1000) + 1 ))

# PROMPT USERNAME
echo -e "\nEnter your username:"
read USERNAME

USER_DATA=$($PSQL "SELECT username, games_played, best_game FROM users WHERE username='$USERNAME'")

# CHECK IF U.NAME ALREADY EXISTS
if [[ -z $USER_DATA ]]; then
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  INSERT_NAME=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")

  # CHECK IF INSERTION WORKED
  if [[ $INSERT_NAME == "INSERT 0 1" ]]; then
    echo "Inserted $USERNAME"
  fi

# USERNAME ALREADY EXISTS
else
  IFS='|' read EXISTING_USERNAME GAMES_PLAYED BEST_GAME <<< "$USER_DATA"
  echo -e "\nWelcome back, $EXISTING_USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# ASK FOR RANDOM NUMBER
GUESS_COUNT=0
while [[ $GUESS -ne $SECRET_NUMBER ]]; do
  echo -e "\nGuess the secret number between 1 and 1000:" 
  read GUESS

  # Check if input is a valid integer
  if [[ ! "$GUESS" =~ ^[0-9]+$ ]]; then
    echo "That is not an integer, guess again:"
    continue
  fi

  # Increment number of guesses made
  GUESS_COUNT=$(( GUESS_COUNT + 1 ))

  if [[ $SECRET_NUMBER -lt $GUESS ]]; then 
    echo "It's lower than that, guess again:"
    
  elif [[ $SECRET_NUMBER -gt $GUESS ]]; then
    echo "It's higher than that, guess again:"

  else
    echo -e "\nYou guessed it in $GUESS_COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"
    break
  fi
done

# UPDATE EXISTING USER DATA
$PSQL "UPDATE users SET games_played = games_played + 1 WHERE username='$USERNAME'" > /dev/null

if [[ -z $BEST_GAME ]] || [[ $GUESS_COUNT -lt $BEST_GAME ]]; then
  $PSQL "UPDATE users SET best_game = $GUESS_COUNT WHERE username='$USERNAME'" > /dev/null
fi
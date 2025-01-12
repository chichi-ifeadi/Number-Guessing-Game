#!/bin/bash
#Number guessing game
#have to add data to database
#loop whil euser guesses numbers
# QUERY DATABASE
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# GENERATE RANDOM NUMBER
SECRET_NUMBER=$(( (RANDOM % 1000) +1 ))

#PROMPT USERNAME
echo -e "\nEnter your username:"
read USERNAME


USER_DATA=$($PSQL "SELECT username, games_played, best_game FROM users WHERE username='$USERNAME'")
echo $USER_DATA
#CHECK IF U.NAME ALREADY EXISTS
if [[ -z $USER_DATA ]] 
then
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
  INSERT_NAME=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")

  #CHECK IF INSERTION WORKED
  if [[ $INSERT_NAME == "INSERT 0 1" ]] 
  then
    echo "Inserted $USERNAME"
  fi

#USERNAME ALREADY EXISTS
else
  IFS='|' read USERNAME GAMES_PLAYED BEST_GAME <<< "$USER_DATA"

  echo Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.

fi

#ASK FOR RANDOM NUMBER
GUESS_NUMBER=0
while [[ $GUESS -ne $SECRET_NUMBER ]]
do [[ echo -e "\nGuess the secret number between 1 and 1000:" ]]

  read GUESS




if [[ $SECRET_NUMBER < GUESS ]]
then 
  echo "It's lower than that, guess again:"
  
elif [[ $SECRET_NUMBER > GUESS ]]
then
  echo "It's higher than that, guess again:"

else
echo "You guessed it in <number_of_guesses> tries. The secret number was $SECRET_NUMBER."
fi

done
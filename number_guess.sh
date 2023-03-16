#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=postgres -t --no-align -c"
# # truncate tables
# echo $($PSQL "truncate table "users", "games"")
# # set sequence to start again with 1
# RESTARTER=$($PSQL "alter sequence users_user_id_seq restart with 1")
# create random number
RANDOM_NUMBER=$(( $RANDOM % 1000 + 1 ))
  #test# echo $RANDOM_NUMBER

# enter username (in database max 22 characters)
echo "Enter your username:"
read USERNAME
# search in database for username
USERNAME_FOUND=$($PSQL "select name from users where name='$USERNAME'")
# if not found
if [[ -z $USERNAME_FOUND ]]
  then
  # insert username in database
  INSERT=$($PSQL "insert into users (name) values ('$USERNAME')")
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  USER_ID=$($PSQL "select user_id from users where name='$USERNAME'")
  else 
  USER_ID=$($PSQL "select user_id from users where name='$USERNAME'")
  GAMES_PLAYED=$($PSQL "select count(game_id) from games where user_id=$USER_ID")
  BEST_GAME=$($PSQL "select min(guess_counter) from games  where user_id=$USER_ID")
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

# define counter variable for guesses
COUNTER=1
# loop until user finds the right number
  echo -e "\nGuess the secret number between 1 and 1000:"
  read GUESS
  
while [ $GUESS -ne $RANDOM_NUMBER ]
do
  # read input from user
# check if input from user equals random number
  if [[ $GUESS -gt $RANDOM_NUMBER ]]
  then
    echo "It's lower than that, guess again:"
  else 
    echo "It's higher than that, guess again:"
  fi
  read GUESS
  # increase counter with every attempt
  let COUNTER++
done
# insert game
INSERT_GAME=$($PSQL "insert into games (guess_counter, user_id) values ($COUNTER, $USER_ID)")
echo "You guessed it in $COUNTER tries. The secret number was $RANDOM_NUMBER. Nice job!"

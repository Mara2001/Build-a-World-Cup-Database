#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE TABLE games, teams;")" > null

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # INSERTING INTO TEAMS TABLE
  #============================

  # skip the first line
  if [[ ! $WINNER == 'winner' ]]
  then
    # look if winner exist in teams table
    #echo -e "\nLooking for $WINNER in teams table:"
    WINNER_REQUEST_RESULT=$($PSQL "SELECT * FROM teams WHERE name='$WINNER';")
    #echo $WINNER_REQUEST_RESULT
    
    # add winner to teams table
    if [[ -z $WINNER_REQUEST_RESULT ]]
    then
      #echo Adding $WINNER to teams table
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")" > null
    #else
      #echo $WINNER found in teams table
    fi
  
    # look if opponent exist in teams table
    #echo -e "\nLooking for $OPPONENT in teams table:"
      OPPONENT_REQUEST_RESULT=$($PSQL "SELECT * FROM teams WHERE name='$OPPONENT';")
      #echo $OPPONENT_REQUEST_RESULT

    # add opponent to teams table
    if [[ -z $OPPONENT_REQUEST_RESULT ]]
    then
      #echo Adding $OPPONENT to teams table
      echo "$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")" > null
    #else
      #echo $OPPONENT found in teams table
    fi

    # INSERTING INTO GAMES TABLE
    #============================

    # looking for winner_id in teams table
    #echo -e "\nLooking for $WINNER ID in teams table:"
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    #echo $WINNER_ID
    # looking for opponent_id in teams table
    #echo -e "\nLooking for $OPPONENT ID in teams table:"
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
    #echo $OPPONENT_ID

    # inserting a row into games table
    echo "$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)\
                    VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);"
          )" > null

  fi
done

#echo "$($PSQL "SELECT FROM;")"
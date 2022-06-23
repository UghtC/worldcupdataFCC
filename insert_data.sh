#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#populate teams database
#teams has to be done first, else nothing to refer to
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $WINNER != "winner" ]]
  then
    #get Team ID
    TEAM_ID=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
    #if team doesn't exist yet
    if [[ -z $TEAM_ID ]]
      then
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      echo Inserted into teams: $WINNER
    fi
  fi
  #repeat for opponent, as not everyone won a game
  if [[ $OPPONENT != "opponent" ]]
    then
    TEAM_ID=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
      if [[ -z $TEAM_ID ]]
      then
      INSERT_TEAM_NAME=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      echo Inserted into teams: $OPPONENT
    fi
  fi
done

#populate games database
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  # don't read first line
  if [[ $YEAR != "year" ]]
    then
    # find winner/opponent ids from teams
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

    # insert into games database
    INSERT_GAME_DATA=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
    echo Inserted into games: $YEAR, $ROUND, $WINNER $WINNER_ID, $OPPONENT $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS
  fi
done




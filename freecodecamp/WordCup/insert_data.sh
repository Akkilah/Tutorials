#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

echo $($PSQL "TRUNCATE teams, games")

# Do not change code above this line. Use the PSQL variable above to query your database.
cat games.csv | while IFS="," read Y R W O W_G O_G 
do
	if [[ $Y != "year" ]]
	then
		# check if the winner team exist otherwize insert 
		WINNER_TEAM_ID=$($PSQL "select team_id from teams where name='$W'")
		if [[ -z $WINNER_TEAM_ID ]]
		then
			echo $($PSQL "insert into teams(name) values('$W')")
			WINNER_TEAM_ID="$($PSQL "select team_id  from teams where name='$W'")"
			#echo "$Y + $W + $O"
		fi
		# check if the winner team exist otherwize insert
		OPPONENT_TEAM_ID=$($PSQL "select team_id from teams where name='$O'")
		if [[ -z $OPPONENT_TEAM_ID ]]
		then
			echo $($PSQL "insert into teams(name) values('$O')")
			OPPONENT_TEAM_ID=$($PSQL "select team_id from teams where name='$O'")
			#echo "$Y + $W + $O"
		fi
		 echo $($PSQL "insert into games(year,round,winner_id,opponent_id, winner_goals,opponent_goals) values ('$Y','$R',$WINNER_TEAM_ID,$OPPONENT_TEAM_ID,$W_G,$O_G)" )
	fi
done

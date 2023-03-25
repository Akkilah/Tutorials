#!/bin/bash
if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
  exit
fi
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#if char else int
if [[ $(($1)) != $1 ]]; then
    #Not just a number
      RESULT=$($PSQL "select * from elements full join properties  using(atomic_number) full join types using(type_id) where symbol= '$1' ")
      if [[ -z $RESULT ]];then
        RESULT=$($PSQL "select * from elements full join properties  using(atomic_number) full join types using(type_id) where name= '$1' ")
      fi
      
    else
    #Just a Number
      RESULT=$($PSQL "select * from elements full join properties  using(atomic_number) full join types using(type_id) where atomic_number = '$1' ")
fi


# check if the result is empty 
if [[ -z $RESULT ]]
then
  echo "I could not find that element in the database."
  exit
fi


echo $RESULT | while IFS="|" read TYPE_ID ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MEL_POINT BOIL_POINT TYPE
do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MEL_POINT celsius and a boiling point of $BOIL_POINT celsius."
done 
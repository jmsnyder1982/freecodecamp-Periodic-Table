#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
   INPUT=$1
  if [[ $1 =~ [0-9]+$ ]]
  then
    ATOMIC_NUMBER=$1
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
    if [[ $SYMBOL = "" ]]
    then
      echo "I could not find that element in the database."
    else
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
      TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$1")
      TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
      ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$1")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$1")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$1")
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi
  else
    CAPITALIZED_INPUT=${INPUT^}
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$CAPITALIZED_INPUT' or name = '$CAPITALIZED_INPUT'")
    if [[ $ATOMIC_NUMBER == "" ]]
    then
      echo "I could not find that element in the database."
    else
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
      TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID")
      ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    fi
  fi
fi

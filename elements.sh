#!/bin/bash

if [[ -z $1 ]]
then
  echo -e "Please provide an element as an argument."
else
  PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

  INPUT=$1
  COLUMNS="atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius"
  if [[ $INPUT =~ ^[0-9]+$ ]]
  then 
    CONDITION="atomic_number = $INPUT"
  else
    CONDITION="symbol = '$INPUT' OR name = '$INPUT'"
  fi

  ELEMENT=$($PSQL "SELECT $COLUMNS from elements\
  JOIN properties USING (atomic_number) \
  JOIN types USING (type_id) \
  WHERE $CONDITION")
  
  if [[ -z $ELEMENT ]]
  then
    echo "I could not find that element in the database."
  else
  read NUMBER BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELT BAR BOIL <<< $ELEMENT
  echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  fi
fi
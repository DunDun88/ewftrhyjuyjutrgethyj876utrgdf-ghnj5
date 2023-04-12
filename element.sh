#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


if [[ -z $1 ]] 
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]$ ]]
  then
    NUMBER=$1
    QUERRY=$($PSQL "SELECT name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number=properties.atomic_number JOIN types ON types.type_id=properties.type_id WHERE elements.atomic_number=$NUMBER")
    if [[ ! -z $QUERRY ]]
    then
      IFS="|" read NAME SYMBOL TYPE MASS MELT BOIL <<< $QUERRY 
      EXISTS='0'
    fi
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    SYMBOL=$1
    QUERRY=$($PSQL "SELECT elements.atomic_number, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number=properties.atomic_number JOIN types ON types.type_id=properties.type_id WHERE symbol='$SYMBOL'")
    if [[ ! -z $QUERRY ]]
    then
      IFS="|" read NUMBER NAME TYPE MASS MELT BOIL <<< $QUERRY 
      EXISTS='0'
    fi
  elif [[ $1 =~ ^[a-zA-Z]+$ ]]
  then
    NAME=$1
    QUERRY=$($PSQL "SELECT elements.atomic_number, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties ON elements.atomic_number=properties.atomic_number JOIN types ON types.type_id=properties.type_id WHERE name='$NAME'")
    if [[ ! -z $QUERRY ]]
    then
      IFS="|" read NUMBER SYMBOL TYPE MASS MELT BOIL <<< $QUERRY
      EXISTS='0'
    fi
  fi

  if [[ ! -z $EXISTS ]]
  then
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  else
    echo "I could not find that element in the database."
  fi
fi

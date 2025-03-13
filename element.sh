#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  ELEMENT_EXISTS=$($PSQL "SELECT * FROM elements WHERE atomic_number::TEXT = '$1' OR symbol = '$1' OR name = '$1';")

  if [[ -z $ELEMENT_EXISTS ]]
  then
    echo "I could not find that element in the database."
  else
    ELEMENT_INFO=$($PSQL "
      SELECT 
        e.atomic_number,
        e.symbol,
        e.name,
        t.type,
        p.atomic_mass,
        p.melting_point_celsius,
        p.boiling_point_celsius
      FROM properties p 
        JOIN elements e USING(atomic_number)
        JOIN types t USING(type_id)
      WHERE e.atomic_number::TEXT = '$1' OR e.symbol = '$1' OR e.name = '$1';
    ")

    echo "$ELEMENT_INFO" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
    done

  fi
fi


#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~ Welcome to allie's salon~~\n"

SERVICES_MENU() {
  # If there's an argument provided, give the user that message 
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi 
  # List Services Prompt user to select a service
  # Service 1
  # Service 2
  # Service 3
  # Exit program
  echo "How can allie's service you today?"  

  echo -e "\n1) cut\n2) color\n3) style 4) EXIT\n"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) APPOINTMENT 1 ;;
    2) APPOINTMENT 2 ;;
    3) APPOINTMENT 3 ;;
    4) EXIT ;;
    # IF INVALID SERVICE SELECTION
      # Loop back to Services Menu / tell customer to select a valid option
    *) SERVICES_MENU "Please enter a valid option." ;;
  esac
}

# ELSE IF VALID SERVICE SELECTION
APPOINTMENT() {
  # set SERVICE_ID_SELECTED TOT EQUAL THE ARGUMENT PROVIDED    
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$1")
  # Ask for phone number
  echo -e "\nMay I have your phone number please?"
  read CUSTOMER_PHONE
  # Lookup customer in table
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  # IF CUSTOMER DOESN'T EXIST
  if [[ -z $CUSTOMER_NAME ]]
  then
    # Ask customer for name
    echo "Welcome to the club, may I get your name?"
    read CUSTOMER_NAME
    # Enter customer phone number and name into customers table
    ADD_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi

  # Find the customers' customer_id from customers table
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

  # Ask customer for time of SERVICE_TIME of appointment
  echo "What time would you like to set your appointment for $CUSTOMER_NAME?"
  read SERVICE_TIME
  # Create an appointment in appointments table user customer ID, service ID and Time
  ADD_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $1, '$SERVICE_TIME')")
  # Output message I have put you down for a <service> at <time>, <name>. 
  echo "I have put you down for a$SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."  
}

EXIT() {
  echo -e "\nThank you for choosing allie's!\n"
}

SERVICES_MENU

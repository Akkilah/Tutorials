#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --no-align --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~"

echo -e "\nWelcome to My Salon, how can I help you?"
SERVICES=$($PSQL "select count(*) from services ");
COUNT=1
while [[ $COUNT -le $SERVICES ]];
do
  echo " $COUNT) $($PSQL "select name from services where service_id = $COUNT " ) "
  let COUNT+=1
done

read SERVICE_ID_SELECTED

# Handling bad input 
if [[ !($SERVICE_ID_SELECTED -le $SERVICES) || $SERVICE_ID_SELECTED  == "" || $SERVICE_ID_SELECTED -le 0  ]]
then
  while :
  do
    echo -e "\nI could not find that service. What would you like today?"
    COUNT=1
    while [[ $COUNT -le $SERVICES ]];
    do
      echo " $COUNT) $($PSQL "select name from services where service_id = $COUNT " ) "
      let COUNT+=1
    done

    read SERVICE_ID_SELECTED
    #if the input is correct break the invint loop
    if [[ $SERVICE_ID_SELECTED -le $SERVICES ]]
    then
      break
    fi

  done
fi

echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE

 CUSTOMER_NAME=$($PSQL "select name from customers where phone = '$CUSTOMER_PHONE' " )

  if [ -z "$CUSTOMER_NAME" ]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    ($PSQL "insert into customers(phone,name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    
  fi

CUSTOMER_ID=$($PSQL"select customer_id from customers where phone='$CUSTOMER_PHONE'")
SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED  ");
echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
read SERVICE_TIME
($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED  ");
echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
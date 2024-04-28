#! /bin/bash

# Function to display the title and header
display_header() {
    echo -e "\n~~~~~ MY SALON ~~~~~\n"
    echo -e "\nWelcome to MY SALON. Please select your preferred service identification number.\n"
}

# Function to display the list of services
display_services() {
    local psql_command="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
    if [[ $1 ]]; then
        echo -e "\n$1\n"
    fi
    local services_offered=$($psql_command "SELECT service_id, name FROM services ORDER BY service_id")
    echo "$services_offered" | while read service_id bar name; do
        echo "$service_id) $name"
    done
}

# Function to handle the selection of services
select_service() {
    read -p "Enter the service ID: " service_id_selected
    
    local psql_command="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"
    local service_name=$($psql_command "SELECT name FROM services WHERE service_id = '$service_id_selected'")
    local service_id=$($psql_command "SELECT service_id FROM services WHERE service_id = '$service_id_selected'")
    
    if [[ ! $service_id_selected =~ ^[0-9]+$ ]]; then
        display_services "Wrong input. That is not a number, please select a valid service identification number"
        elif [[ -z $service_id ]]; then
        display_services "There is no service here. Please select a valid service identification number."
    else
        read -p "Please enter your phone number: " customer_phone
        local customer_name=$($psql_command "SELECT name FROM customers WHERE phone = '$customer_phone'")
        
        if [[ -z $customer_name ]]; then
            read -p "I don't have a record for that phone number, please input your name: " customer_name
            local new_customer=$($psql_command "INSERT INTO customers(phone, name) VALUES('$customer_phone', '$customer_name')")
        fi
        
        read -p "Please input a suitable time for your $service_name, $customer_name: " service_time
        
        if [[ $service_time ]]; then
            local customer_id=$($psql_command "SELECT customer_id FROM customers WHERE phone = '$customer_phone'")
            local new_appointment=$($psql_command "INSERT INTO appointments(service_id, customer_id, time) VALUES('$service_id_selected', '$customer_id', '$service_time')")
            
            if [[ $new_appointment == 'INSERT 0 1' ]]; then
                echo "I have put you down for a $service_name at $service_time, $customer_name."
            fi
        fi
    fi
}

# Main script starts here
display_header
display_services
select_service

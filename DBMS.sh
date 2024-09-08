GREEN="\e[32m"
RED="\e[31m"
RESET="\e[0m"
shopt -s extglob #enable subpattern
if [[ -d ~/DBMS ]]; then
    echo "Welcome to DBMS!"
else
    mkdir ~/DBMS
    echo "Welcome to DBMS!"
fi

Test_DB_Name(){
    shopt -s extglob  # Enable extended globbing
    local input=$(echo $@ | tr ' ' '_')

    if [[ -d ~/DBMS/$input ]]; then
        echo "This DB is already Exists!"
    else
        case $input in
        +([a-zA-Z0-9_]))
            if [[ $input = [0-9]* ]]; then
                echo "DB Name can't start with numbers"
            else
                echo "$input DB created successfully!"
                mkdir ~/DBMS/$input
            fi        
        ;;
        *)
            echo "DB Name Can't Contain Special Characters"
        ;;
        esac
    fi    
}

Test_Table_Name(){
    shopt -s extglob  # Enable extended globbing
    local input=$(echo "$1" | tr ' ' '_')

    if [[ -f ~/DBMS/$2/$input ]]; then
        echo "This Table is already Exists!"
    else
        case $input in
            +([a-zA-Z0-9_]))
                if [[ $input = [0-9]* ]]; then
                    echo "Table Name can't start with numbers"
                else
                    echo " "    
                fi        
        ;;
        *)
            echo "Table Name Can't Contain Special Characters"
        ;;
        esac
    fi    
}


while true;
do
    PS3="Main>>"
    echo "-----------Main Menu-----------"
    select var in "Create DB" "List DB" "Connect DB" "Remove DB" "Exit"
    do
    case $REPLY in
    1) 
        read -p "Enter Name of DB: " -a name
        Test_DB_Name $name
        break
    ;;

    2)
        if [ -z "$(ls ~/DBMS)" ]; then
            echo "No DB Created!"
        else
            echo "-------DataBases-------"
            ls ~/DBMS
            
        fi
        break
    ;;

    3)
        if [ -z "$(ls ~/DBMS)" ]; then
            echo "No DB Created to connect!"
        else
            echo "=======DataBases======="
            PS3="Choose a DB >> "
            select db_connect in $(ls ~/DBMS)
            do 
                if [[ $REPLY -le $(ls ~/DBMS | wc -w) ]]; then
                    break
                else
                    echo "----------------------------"
                    echo "please enter right choice"
                    echo "----------------------------"
                    continue
                fi    
            done
            if [[ -d ~/DBMS/$db_connect ]]; then 
                echo "-------------------------"
                echo "connected successfully!"
                echo "-------------------------"
                while true;
                do
                    echo "-----------Tables Menu-----------"
                    PS3="$db_connect>>"
                    select menu in "Create Table" "List Table" "Drop Table" "insert into table" "delete from table" "update table" "select from table" "previous menu"
                    do
                        case $REPLY in
                        1)
                            read -p "Enter Name of the Table: " table_name
                            echo "-----------------------------"
                            check=$(Test_Table_Name $table_name $db_connect)
                            if [[ $check == "Table Name can't start with numbers" || $check == "Table Name Can't Contain Special Characters" ]]; then
                                echo $check
                                echo " "                  
                            else     
                                read -p "enter number of columns: " num_col
                                table_meta_data=()
                                for ((i=0; i<$num_col; i++))
                                do 
                                    if (( i==0 ))
                                    then
                                        echo "-----------------------------------------"
                                        echo "Note that the first column will be pk"
                                        echo "-----------------------------------------"
                                        read -p "Column $(($i+1)): " new
                                        echo "-----------------------------------------"
                                        # read -p "what is the type ? int or text: " col_type

                                        PS3="Choose the constraint of the Column >> "
                                        select col_type in "int" "string"
                                        do 
                                            if [[ $REPLY -le 2 ]]; then
                                                break
                                            else
                                                echo "----------------------------"
                                                echo "please enter right choice"
                                                echo "----------------------------"
                                                continue
                                            fi    
                                        done
                                        echo "-----------------------------------------"    
                                        table_meta_data+=($new"[PK][$col_type]")
                                    else 
                                        read -p "Column $(($i+1)): " new
                                        echo "-----------------------------------------"
                                        # read -p "what is the type ? int or text: " col_type
                                        PS3="Choose the constraint of the column >> "
                                        select col_type in "int" "string"
                                        do 
                                            if [[ $REPLY -le 2 ]]; then
                                                break
                                            else
                                                echo "----------------------------"
                                                echo "please enter right choice"
                                                echo "----------------------------"
                                                continue
                                            fi    
                                        done
                                        echo "-----------------------------------------"
                                        table_meta_data+=($new[$col_type])   
                                    fi
                                done
                                echo "$table_name Table created successfully!"
                                echo "-----------------------------------------"
                                touch ~/DBMS/$db_connect/$table_name
                                comma_separated=$(IFS=,; echo "${table_meta_data[*]}") # CONCAT all elements that's in the array with a seperator
                                echo $comma_separated >> ~/DBMS/$db_connect/$table_name
                            fi    
                            break
                        ;;

                        2)
                            if [ -z "$(ls ~/DBMS/$db_connect)" ]; then
                                echo "No Tables Created!"
                            else
                                echo "--------Tables--------"
                                ls ~/DBMS/$db_connect
                            fi
                            break
                        ;;

                        3)
                            if [ -z "$(ls ~/DBMS/$db_connect)" ]; then
                                echo "No Tables Created to remove!"
                                echo "-----------------------------"
                            else
                                echo "--------Tables--------"
                                PS3="Which Table do you want to drop? >>"
                                select table_drop in $(ls ~/DBMS/$db_connect)
                                do 
                                    if [[ $REPLY -le $(ls ~/DBMS/$db_connect | wc -w) ]]; then
                                        break
                                    else
                                        echo "----------------------------"
                                        echo "please enter right choice"
                                        echo "----------------------------"
                                        continue
                                    fi    
                                done
                                echo "-----------------------------------"
                                if [[ -d ~/DBMS/$db_connect ]]; then 
                                    rm ~/DBMS/$db_connect/$table_drop
                                    echo "$table_drop Table dropped successfully!"
                                    echo "-----------------------------------"
                                else
                                    echo "Please Enter Correct Name"
                                fi
                            fi
                            break
                        ;;

                        4)
                            if [ -z "$(ls ~/DBMS/$db_connect)" ]; then
                                echo "No Tables Created to insert into!"
                                echo "-----------------------------"
                            else
                                echo "--------Tables--------"
                                PS3="Which Table do you want to insert into? >>"
                                select table_insert in $(ls ~/DBMS/$db_connect)
                                do 
                                    if [[ $REPLY -le $(ls ~/DBMS/$db_connect | wc -w) ]]; then
                                        break
                                    else
                                        echo "----------------------------"
                                        echo "please enter right choice"
                                        echo "----------------------------"
                                        continue
                                    fi    
                                done
                                if [[ -f ~/DBMS/$db_connect/$table_insert ]]; then 
                                number_of_columns=$(awk -F , '{print NF}' ~/DBMS/$db_connect/$table_insert | head -n 1)
                                inserted_values=()
                                for (( i=1; i<=$number_of_columns; i++ ))
                                do
                                    get_column_name=$(head -n 1  ~/DBMS/$db_connect/$table_insert | awk -F , -v col="$i" '{print $col}')
                                    get_constraint=$(echo $get_column_name | grep -oE 'int|string')
                                    while true;
                                    do
                                        read -p "Enter value for $get_column_name: " value
                                        if [[ ($get_constraint == "int" && $value =~ ^[0-9]+$) || ($get_constraint == "string" && $value =~ ^[a-zA-Z_@#$%]+$) ]]; then
                                            if [[ $i == 1 ]]; then 
                                                if [[ -z "$(sed -n "/^$value/p" ~/DBMS/$db_connect/$table_insert)" ]]; then #check if the primary key is existed before in the table or not
                                                    :
                                                else
                                                    echo -e "${RED}Primary key must be unique value in the column please try again!${RESET}"
                                                    echo " "
                                                    continue
                                                fi
                                            else
                                                :
                                            fi
                                            echo "-----------------------"
                                            inserted_values+=($value)
                                            continue 2
                                        else
                                            echo -e "${RED}follow the constraint to insert!${RESET}"
                                            echo "------------------------------"
                                            continue
                                        fi
                                    done
                                done
                                echo -e "${GREEN}values inserted successfully${RESET}"
                                echo " "
                                inserted_comma_separated=$(IFS=,; echo "${inserted_values[*]}")
                                echo $inserted_comma_separated >> ~/DBMS/$db_connect/$table_insert       
                                else
                                    echo "Please Enter Correct Name"
                                fi
                            fi
                            break 
                        ;;

                        5)
                            if [[ -z "$(ls ~/DBMS/$db_connect)" ]]; then 
                                echo -e "${GREEN}No Tables Created to delete from!${RESET}"
                            else
                                echo "--------Tables--------"
                                PS3="Which Table do you want to delete from? >>"
                                select delete_from_table in $(ls ~/DBMS/$db_connect)
                                do 
                                    if [[ $REPLY -le $(ls ~/DBMS/$db_connect | wc -w) ]]; then
                                        break
                                    else
                                        echo "----------------------------"
                                        echo -e "${RED}please enter right choice${RESET}"
                                        echo "----------------------------"
                                        continue
                                    fi    
                                done
                                echo "-----------------------------------"
                                number_of_columns=$(awk -F , '{print NF}' ~/DBMS/$db_connect/$delete_from_table | head -n 1)
                                options=$(cat ~/DBMS/$db_connect/$delete_from_table | head -n 1 | tr ',' ' ')
                                options+=" delete_all_data exit"
                                while true
                                do
                                    echo "which column do you want to delete by? "
                                    echo " "    
                                    select var in $options
                                    do 
                                        if (( $REPLY >=1 && $REPLY <= $number_of_columns ))
                                        then 
                                            if [[ $REPLY == 1 ]]; then
                                                read -p "enter the value to delete the record: " value
                                                echo " "
                                                sed -i "/^$value/d" ~/DBMS/$db_connect/$delete_from_table
                                                echo -e "${GREEN}record deleted successfully${RESET}"
                                                echo "-----------------------------------"
                                                break
                                            else
                                                read -p "enter the value to delete the record/s: " value
                                                number_of_records=$(awk -F , -v var=$REPLY '{print $var}' ~/DBMS/$db_connect/$delete_from_table | grep "$value" | wc -l)
                                                if [[ $number_of_records > 0 ]]; then
                                                    k=$(awk -F , -v col="$REPLY" -v val=$value '{ if ($col != val) {print $0 }}' ~/DBMS/$db_connect/$delete_from_table)
                                                    > ~/DBMS/$db_connect/$delete_from_table
                                                    echo $k | tr ' ' '\n' >> ~/DBMS/$db_connect/$delete_from_table 
                                                    echo -e "${GREEN}$number_of_records records deleted successfully.${RESET}"
                                                    echo " "
                                                    break
                                                else
                                                    echo -e "${RED}there are no records to delete!${RESET}"
                                                    echo " "
                                                    break
                                                fi
                                            fi
                                        elif (( $REPLY == $((number_of_columns+1)) ))
                                        then
                                            sed -i '2,$d' ~/DBMS/$db_connect/$delete_from_table
                                            echo -e "${GREEN}all data deleted successfully!${RESET}"
                                            echo " "
                                            break 3
                                        elif (( $REPLY == $((number_of_columns+2)) ))
                                        then
                                            echo " "
                                            break 3
                                        else
                                            echo -e "${RED}wrong argument!${RESET}"
                                            echo " "
                                            break
                                        fi    
                                    done
                                done
                            fi
                        ;;

                        6)
                            if [[ -z "$(ls ~/DBMS/$db_connect)" ]]; then 
                                echo -e "${RED}There are no Tables Created to update it!${RESET}"

                            else
                                echo "--------Tables--------"
                                PS3="Which Table do you want to update? >>"
                                select update_table in $(ls ~/DBMS/$db_connect)
                                do 
                                    if [[ $REPLY -le $(ls ~/DBMS/$db_connect | wc -w) ]]; then
                                        break
                                    else
                                        echo "----------------------------"
                                        echo -e "${RED}please enter right choice${RESET}"
                                        echo "----------------------------"
                                        continue
                                    fi    
                                done

                                echo "-----------------------------------"
                                number_of_columns=$(awk -F , '{print NF}' ~/DBMS/$db_connect/$update_table | head -n 1)
                                options=$(cat ~/DBMS/$db_connect/$update_table | head -n 1 | tr ',' ' ')
                                
                                    while true
                                    do
                                        echo "which column do you want to update by? "
                                        echo " "    
                                        select var in "update a column by the primary key" "update a specific column"
                                        do
                                            case $REPLY in 
                                            1)
                                                read -p "enter the primary key: " pk
                                                echo "which column do you want to update by primary key? "
                                                if [[ -z "$(sed -n "/^$pk/p" ~/DBMS/$db_connect/$update_table)" ]]; then #check if the primary key is existed before in the table or not
                                                    echo -e "${RED}Primary key doesn't exist please try again!${RESET}"
                                                    echo " "
                                                    break 3
                                                else
                                                    pk_options=$(echo $options | cut -d ' ' -f "2-$number_of_columns")
                                                    pk_options+=" exit"
                                                    echo " "
                                                    select var in $pk_options
                                                    do                                                        
                                                        if (( $REPLY >= 1 && $REPLY <= $(($number_of_columns - 1)) )); then 
                                                            reply_new=$(($REPLY + 1))
                                                            read -p "What is the new value of $var? " new_value
                                                            old=$(sed -n "/^$pk/p" ~/DBMS/$db_connect/$update_table | cut -d ',' -f $reply_new)
                                                            sed -i "/^$pk/s/$old/$new_value/" ~/DBMS/$db_connect/$update_table
                                                            
                                                            echo -e "${GREEN}Value updated successfully!${RESET}"
                                                            echo " "
                                                            break 4

                                                        elif (( $REPLY == $number_of_columns )); then    
                                                            echo " "
                                                            break 4

                                                        else
                                                            echo -e "${RED}Please enter the right argument.${RESET}"
                                                            echo " "
                                                            break 4
                                                        fi 
                                                    done                                                                                
                                                fi
                                            ;;

                                            2)
                                                echo "which column do you want to update? "
                                                echo " "
                                                options=$(cat ~/DBMS/$db_connect/$update_table | head -n 1 | tr ',' ' ')
                                                options+=" exit"
                                                while true
                                                do
                                                    select var in $options
                                                    do
                                                        if (( $REPLY >=1 && $REPLY <= $number_of_columns ))
                                                        then 
                                                            if [[ $REPLY == 1 ]]; then
                                                                read -p "Enter old value of $var you want to change: " old
                                                                if [[ -z "$(sed -n "/^$old/p" ~/DBMS/$db_connect/$update_table)" ]]; then
                                                                    echo -e "${RED}that value doesn't exist please try again.${RESET}"
                                                                    echo " "
                                                                    break
                                                                else
                                                                    read -p "enter the new value of the column: " new_value        
                                                                    if [[ -z "$(sed -n "/^$new_value/p" ~/DBMS/$db_connect/$update_table)" ]]; then
                                                                        sed -i "/^$old/s/$old/$new_value/" ~/DBMS/$db_connect/$update_table
                                                                        echo -e "${GREEN}record updated successfully${RESET}"
                                                                        echo "-----------------------------------"                                                                        
                                                                    else
                                                                    echo -e "${RED}the new value of primary key already exists! please try again${RESET}"
                                                                    echo " "
                                                                    fi                                                                    
                                                                    break
                                                                fi     
                                                            else
                                                                read -p "enter the old value that you want to update: " old_value
                                                                number_of_records=$(awk -F , -v var=$REPLY '{print $var}' ~/DBMS/$db_connect/$update_table | grep "$old_value" | wc -l)
                                                                if [[ $number_of_records > 0 ]]; then
                                                                    read -p "enter the new value: " new_value
                                                                    awk -F, -v col="$REPLY" -v search="$old_value" -v replace="$new_value" '
                                                                    NR == 1 {print; next}
                                                                    $col == search { $col = replace }
                                                                    {print}' ~/DBMS/$db_connect/$update_table | tr ' ' ',' > temp && mv temp ~/DBMS/$db_connect/$update_table        
                                                                    echo -e "${GREEN}records updated successfully.${RESET}"
                                                                    echo " "
                                                                    break
                                                                else
                                                                    echo -e "${RED}no records to update!${RESET}"
                                                                    echo " "
                                                                    break
                                                                fi
                                                            fi
                                                        elif (( $REPLY == $((number_of_columns+1)) ))
                                                        then                                                            
                                                            break 5
                                                        else
                                                            echo -e "${RED}wrong argument !${RESET}"
                                                            echo " "
                                                            break
                                                        fi 

                                                    done
                                                done
                                            ;;

                                            *)
                                                echo "error"
                                            ;; 
                                            esac
                                                                            
                                        done
                                    done
                            fi
                        ;;

                        7)
                            if [[ -z "$(ls ~/DBMS/$db_connect)" ]]; then 
                                echo "There are no Tables Created to select from"
                            else
                                echo "--------Tables--------"
                                PS3="Which Table do you want to select from? >>"
                                select table in $(ls ~/DBMS/$db_connect)
                                do 
                                    if [[ $REPLY -le $(ls ~/DBMS/$db_connect | wc -w) ]]; then
                                        break
                                    else
                                        echo "----------------------------"
                                        echo "please enter right choice"
                                        echo "----------------------------"
                                        continue
                                    fi    
                                done
                                echo "-----------------------------------"
                                number_of_columns=$(awk -F , '{print NF}' ~/DBMS/$db_connect/$table | head -n 1)
                                options=$(cat ~/DBMS/$db_connect/$table | head -n 1 | tr ',' ' ')
                                options+=" previous_menu"
                                PS3="choose an option >>"
                                while true
                                do
                                    PS3="choose an option >>"
                                    select variable in "select all data" "select all data with condition" "select columns" "select columns with condition" "previous menu"
                                    do
                                    case $REPLY in 
                                    1)
                                    echo "------------------------------------"
                                    cat ~/DBMS/$db_connect/$table
                                    echo "------------------------------------"
                                    break
                                    ;;
                                    2)
                                    while true; do
                                        PS3="Which column do you want to make the condition by? >> "                  
                                        select var in $options; do

                                            if (( REPLY >= 1 && REPLY <= number_of_columns )); then
                                                read -p "enter the value of $var to filter out the data: " value_search
                                                echo "--------------------------------"
                                                awk -F, -v col="$REPLY" -v search="$value_search" '
                                                NR == 1 {print; next}
                                                $col == search {print}' ~/DBMS/$db_connect/$table
                                                echo "--------------------------------"
                                                echo " "
                                                break 

                                            elif (( REPLY == number_of_columns + 1 )); then
                                                break 3

                                            else 
                                                echo "Please enter a valid argument"
                                                break 
                                            fi
                                        done
                                    done    
                                    ;;

                                    3)
                                    echo " "
                                    while true; do                                    
                                        for i in $(seq 1 $((number_of_columns+1))); do
                                            echo "${options[i-1]}"
                                        done | tr ' ' '\n' | sed -n "1,$((number_of_columns+1))p" | awk '{print NR ,$0}'
                                        echo " "
                                        read -p "select columns like that --> 1,2,.. | $(($number_of_columns + 1)) --> exit >> " cols               
                                        if (( $cols == number_of_columns + 1 )); then
                                            break 2
                                        else
                                        echo "--------------------------------------------------------" 
                                            cut -d ',' -f $cols ~/DBMS/$db_connect/$table | tr ' ' ',' 
                                        echo "--------------------------------------------------------"    
                                        fi
                                    done                                    
                                    ;;

                                    4)
                                    while true; do
                                        PS3="Which column do you want to make the condition by? >> "                  
                                        select var in $options; do 
                                            if (( REPLY >= 1 && REPLY <= number_of_columns )); then
                                                read -p "enter the value of $var to filter out the data: " value_search
                                                echo "--------------------------------"
                                                echo " "
                                                while true; do                                    
                                                    for i in $(seq 1 $((number_of_columns+1))); do
                                                        echo "${options[i-1]}"
                                                    done | tr ' ' '\n' | sed -n "1,$((number_of_columns+1))p" | awk '{print NR ,$0}'
                                                    echo " "
                                                    read -p "select columns to show filtered data like that --> 1,2,.. | $(($number_of_columns + 1)) --> exit >> " cols               
                                                    if (( $cols == number_of_columns + 1 )); then
                                                        echo " "
                                                        break 2
                                                    else
                                                    echo "--------------------------------------------------------" 
                                                        awk -F, -v col="$REPLY" -v search="$value_search" 'NR == 1 {print; next} $col == search {print}' ~/DBMS/$db_connect/$table | cut -d ',' -f $cols | tr ' ' ',' 
                                                    echo "--------------------------------------------------------"    
                                                    fi
                                                done
                                                break 

                                            elif (( REPLY == number_of_columns + 1 )); then
                                                break 3

                                            else 
                                                echo "Please enter a valid argument"
                                                break 
                                            fi
                                        done
                                    done
                                    ;;

                                    5)

                                        echo " "
                                        break 3
                                    ;;

                                    *)
                                    echo "Error: Invalid choice"
                                    break 3
                                    ;;

                                esac        
                                    done                                 
                                done
                            fi
                        ;;
                        8)
                        break 3
                        ;;

                        *)
                        echo "error"
                        ;;
                        esac

                    done
                done
            else
                echo "Please Enter Correct Name!"
                echo " "
            fi
        fi
        break
    ;;

    4)
        if [ -z "$(ls ~/DBMS)" ]; then
            echo "No DB Created to remove!"
        else
            echo "=======DataBases======="
            PS3="Choose a DB to remove >> "
            select db_remove in $(ls ~/DBMS)
            do 
                if [[ $REPLY -le $(ls ~/DBMS | wc -w) ]]; then
                    break
                else
                    echo "----------------------------"
                    echo "please enter right choice"
                    echo "----------------------------"
                    continue
                fi    
            done
            
            if [[ -d ~/DBMS/$db_remove ]]; then 
                rm -r ~/DBMS/$db_remove
                echo "$db_remove DB removed successfully!"
            else
                echo "Please Enter Correct Name"
            fi
        fi
        break
    ;;

    5)
    break 2
    ;;
    esac
    done
done
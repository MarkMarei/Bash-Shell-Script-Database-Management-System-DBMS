# Bash Shell Script Database Management System (DBMS)

## About the project
This project is a simple Database Management System (DBMS) implemented using Bash shell scripting. The main objective is to provide users with a way to store and retrieve data from the disk via a command-line interface (CLI). The program offers a menu-driven interface for interacting with the database, making it user-friendly for managing databases and tables.

## Features

### Main Menu
1. **Create Database**  
   Allows the user to create a new database.
2. **List Databases**  
   Lists all existing databases.
3. **Connect to Database**  
   Connects the user to a specific database
4. **Drop Database**  

### Database Menu
after connected to a database

1. **Create Table**  
   Allows the user to create a new table within the connected database.
2. **List Tables**  
   Lists all tables in the connected database.
3. **Drop Table**  
   Deletes an existing table from the connected database.
4. **Insert into Table**  
   Inserts a new record into a specific table.
5. **Select From Table**  
   Retrieves records from a specific table based on user-defined criteria.
6. **Delete From Table**  
   Deletes records from a specific table based on user-defined criteria.
7. **Update Table**  
   Updates records in a specific table based on user-defined criteria.
### How to use it

at first run this command to make the bash file executable command ```chmod u+x path_to_shell_file```

then run this command to can run the program by it's name only ```echo $PATH:/path_to_the_folder_of_shell_file >> ~/.bashrc```

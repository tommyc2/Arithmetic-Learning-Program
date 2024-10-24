#!/bin/bash
#
# Bash Assignment 1
# Arithmetic Learning App
# with Teacher/Student Login Program
# ---------------------------------
# by Tommy Condon - 20101841
# github.com/tommyc2
#
# Random number code source: https://www.baeldung.com/linux/bash-draw-random-ints

NUM_QUESTIONS=20 # number of questions assigned to student
USERS_FILE="users.csv" # list of users stored locally
declare LOGGED_IN_USER # Username of user logged in
declare -a USERDETAILS # can be teacher or student
declare -a teachers_list_of_students # load in teacher's students
maths_facts_file="mathsfacts.txt"


menu()
{

    echo """
    ----------------
    Login
    ---------------
    1. Teacher Login
    2. Student Login
    3. Quit
    ---------------
    -->  """
    read OPTION

    if [ $OPTION -eq 1 ] # Login as teacher
    then
        teacher_login
    elif [ $OPTION -eq 2 ] # Student Login
    then
        student_login # Calling student menu function
    elif [ $OPTION -eq 3 ]
    then
        echo "Exiting program...Bye bye"
        exit 0
    else
        echo -e "Invalid Choice in Menu Function.\n\r"
        menu # function calling itself to start again
    fi
}

student_login()
{
    local USERNAME
    local PASSWORD

    until [[ $USERNAME =~ ^[[:alnum:]]+$ ]]
    do
        read -p "Enter your username (e.g. tcondon007): " USERNAME
        if [[ ! $USERNAME =~ ^[[:alnum:]]+$ ]]
        then
            echo "ERROR: Username must contain letters and numbers only"
        fi
    done

    until [[ $PASSWORD =~ ^[[:alnum:]]+$ ]]
    do
        read -p "Enter your password: " PASSWORD
        if [[ ! $PASSWORD =~ ^[[:alnum:]]+$ ]]
        then
            echo "ERROR: Username must contain letters and numbers only"
        fi
    done

    ENCRYPTED_PASSWORD=$(echo $PASSWORD | openssl dgst -sha256 | cut -d' ' -f2)

    if grep -q "$USERNAME," "$USERS_FILE"
    then
        if grep -q "$USERNAME,$ENCRYPTED_PASSWORD," "$USERS_FILE"
        then
            echo "-----------------"
            echo "Hello $USERNAME!"
            echo "-----------------"

            LOGGED_IN_USER=$USERNAME

            local USER_LINE=$(grep -C 0 "$USERNAME,$ENCRYPTED_PASSWORD" "$USERS_FILE") # the line where the user details are stored, 0 specifies print no lines above/below, just the line
            local USER_LINE_FOR_ARRAY=$(echo "$USER_LINE" | tr ',' ' ') # REPLACES ','' WITH SPACE

            USERDETAILS=($USER_LINE_FOR_ARRAY)

            FIRSTNAME=${USERDETAILS[0]}
            USERNAME=${USERDETAILS[1]}
            PASS=${USERDETAILS[2]}
            LEVEL=${USERDETAILS[3]}
            CLASS=${USERDETAILS[4]}
            QUIZTYPE=${USERDETAILS[5]}
            TABLENUM=${USERDETAILS[6]}
            MAXNUM=${USERDETAILS[7]}
            DOJOPOINTS=${USERDETAILS[8]}
            TEACHER=${USERDETAILS[9]}

            echo ""
            echo "-------------------"
            echo "Welcome $FIRSTNAME!"
            echo "-------------------"
            echo "$date"
            echo "Your class: $CLASS"
            echo "DojoPoints: $DOJOPOINTS"
            echo "Your teacher: $TEACHER"
            echo "-------------------"
            echo ""

            echo ""
            shuf -n 1 $maths_facts_file
            echo ""

            sleep 1

            student_menu

        else
            echo "Wrong password. Please try again."
            student_login
        fi
    else
        echo "User does not exist."
        student_login
    fi

}

teacher_login()
{
    local USERNAME
    local PASSWORD

    until [[ $USERNAME =~ ^[[:alnum:]]+$ ]]
    do
        read -p "Enter your username (e.g. tcondon007): " USERNAME
        if [[ ! $USERNAME =~ ^[[:alnum:]]+$ ]]
        then
            echo "ERROR: Username must contain letters and numbers only"
        fi
    done

    until [[ $PASSWORD =~ ^[[:alnum:]]+$ ]]
    do
        read -p "Enter your password: " PASSWORD
        if [[ ! $PASSWORD =~ ^[[:alnum:]]+$ ]]
        then
            echo "ERROR: Password must contain letters and numbers only"
        fi
    done

    ENCRYPTED_PASSWORD=$(echo $PASSWORD | openssl dgst -sha256 | cut -d' ' -f2)

    if grep -q "$USERNAME," "$USERS_FILE"
    then
        if grep -q "$USERNAME,$ENCRYPTED_PASSWORD," "$USERS_FILE"
        then
            echo "-----------------"
            echo "Hello $USERNAME!"
            echo "-----------------"

            LOGGED_IN_USER=$USERNAME

            local USER_LINE=$(grep -C 0 "$USERNAME,$ENCRYPTED_PASSWORD" "$USERS_FILE") # the line where the user details are stored, 0 specifies print no lines above/below, just the line
            local USER_LINE_FOR_ARRAY=$(echo "$USER_LINE" | tr ',' ' ') # REPLACES ','' WITH SPACE

            USERDETAILS=($USER_LINE_FOR_ARRAY)

            FIRSTNAME=${USERDETAILS[0]}
            USERNAME=${USERDETAILS[1]}
            PASS=${USERDETAILS[2]}
            LEVEL=${USERDETAILS[3]}
            CLASS=${USERDETAILS[4]}
            QUIZTYPE=${USERDETAILS[5]}
            TABLENUM=${USERDETAILS[6]}
            MAXNUM=${USERDETAILS[7]}
            DOJOPOINTS=${USERDETAILS[8]}
            TEACHER=${USERDETAILS[9]}

            echo ""
            echo "-------------------"
            echo "Welcome $FIRSTNAME!"
            echo "$date"
            echo "-------------------"
            echo ""

            load_teachers_students # load students into array
            echo "Logged in as: $LOGGED_IN_USER"

            echo ""
            shuf -n 1 $maths_facts_file
            echo ""

            sleep 1

            teacher_menu

        else
            echo "Wrong password. Please try again."
            teacher_login
        fi
    else
        echo "User does not exist."
        teacher_login
    fi

}

view_student_quiz_results()
{

    if [[ ! -d quiz_results ]]; then
        echo "No available Quiz Results for any student"
        sleep 2
        teacher_menu
    fi
    
    echo "-------------------------------------"
    echo "---- SELECT A STUDENT's RESULTS -----"
    echo "-------------------------------------"

    local number_of_students=${#teachers_list_of_students[@]}

    for((i=0;i<number_of_students;i++))
    do
        echo "$i. ${teachers_list_of_students[$i]}"
        if [[ $i -eq $number_of_students ]]; then
            echo "-----------------------"
        fi
    done

    echo "Choose a number (0-$number_of_students)"
    read -p "--->   " NUM

    if [[ $NUM -ge $number_of_students || $NUM -lt 0 ]]
    then
        echo "Please enter a number between 0-$(($number_of_students-1))"
        view_student_quiz_results
    fi

    # Check quiz_results directory and see if student has results

    local CHOSEN_STUDENT_NAME=${teachers_list_of_students[$NUM]}
    echo ""
    echo "You chose: $CHOSEN_STUDENT_NAME"
    echo ""

    if ls quiz_results | grep -q "$CHOSEN_STUDENT_NAME"
    then
        local ATTEMPTS_OUTPUT=$(ls quiz_results | grep "$CHOSEN_STUDENT_NAME" | cat)
        local ATTEMPTS_ARRAY=()

        while read line
        do
            ATTEMPTS_ARRAY+=("$line")
        done <<< "$ATTEMPTS_OUTPUT"

        echo "=========================================="
        echo "Number of attempts: ${#ATTEMPTS_ARRAY[@]}"
        echo "=========================================="
        for((i=0;i<${#ATTEMPTS_ARRAY[@]};i++))
        do
            echo "($i): ${ATTEMPTS_ARRAY[$i]}"
        done

        echo ""
        read -p "Enter a number:    " N
        
        # View contents of attempt file
        echo ""
        echo "--------------------------------"
        echo "Name: $CHOSEN_STUDENT_NAME"
        echo "Attempt Number: $N"
        echo "---------------------------------"
        cat "quiz_results/${ATTEMPTS_ARRAY[$N]}"
        echo ""

        local WRONG=0
        local TOTAL=0

        while read LINE || [ -n "$LINE" ] # StackOverflow: https://stackoverflow.com/questions/12916352/shell-script-read-missing-last-line
        do
            TOTAL=$(($TOTAL+1))

            if echo "$LINE" | grep -q "Wrong"; then
                WRONG=$(($WRONG+1))
            fi

        done < quiz_results/${ATTEMPTS_ARRAY[$N]}

        echo "---------------------------------"
        echo "Score: $(($TOTAL-$WRONG)) / $TOTAL "
        echo "-----------------------------------"

        read -p "Return to main menu? (y/n):" CHOICE

        if [[ "$CHOICE" == "y" || "$CHOICE" == "Y" ]]; then
            teacher_menu
        else
            view_student_quiz_results
        fi

    else
        echo "No attempts for this student found"
        sleep 2

        read -p "Return to main menu? (y/n):" CHOICE

        if [[ "$CHOICE" == "y" || "$CHOICE" == "Y" ]]; then
            teacher_menu
        else
            view_student_quiz_results
        fi
    fi

}

load_teachers_students()
{
    # Read users.csv line by line and put students usernames into the list
    while read LINE
    do
        if [[ "$LINE" =~ "$USERNAME" ]]; then # teachers username
            FIRST_CELL=$(echo "$LINE" | cut -d',' -f1)
            if [[ "$FIRST_CELL" != "$FIRSTNAME" ]]
            then
                STUDENT_NAME=$(echo "$LINE" | cut -d',' -f1)
                teachers_list_of_students+=("$STUDENT_NAME")
            fi
        fi

    done < $USERS_FILE
     

    echo "Loaded students....."
}

manage_users()
{
    echo "-------------------------------------"
    echo "--------  MANAGE USERS  -------------"
    echo "-------------------------------------"

    local number_of_students=${#teachers_list_of_students[@]}

    for((i=0;i<number_of_students;i++))
    do
        echo "$i. ${teachers_list_of_students[$i]}"
        if [[ $i -eq $number_of_students ]]; then
            echo "-----------------------"
        fi
    done

    echo ""
    echo "Choose a number (0-$number_of_students)"
    read -p "--->   " NUM

    if [[ $NUM -ge $number_of_students || $NUM -lt 0 ]]
    then
        echo "Please enter a number between 0-$(($number_of_students-1))"
        manage_users
    fi

    local CHOSEN_STUDENT_NAME=${teachers_list_of_students[$NUM]}
    echo ""
    echo "You chose: $CHOSEN_STUDENT_NAME. What do you want to do with this student?"
    echo "1. Delete student"
    echo "2. View student stats"
    echo "3. Go Back"
    read -p "-->   " OP
    echo ""

    if [[ $OP -eq 1 ]]; then
        echo "delete"
    elif [[ $OP -eq 2 ]]; then
        view_student_stats $OP
    elif [[ $OP -eq 3 ]]; then
        manage_users
    else
        echo "You must enter a number between 1-3"
        echo "Going back to Manage Users menu..."
        sleep 1
        manage_users
    fi
    
    


}

view_student_stats()
{
    local student_attempts_array=($(ls quiz_results | grep "$CHOSEN_STUDENT_NAME"))

    local SCORE_TALLY=0

    for((i=0;i<${#student_attempts_array[@]};i++))
    do
        while read LINE || [ -n "$LINE" ] # StackOverflow: https://stackoverflow.com/questions/12916352/shell-script-read-missing-last-line
        do
            if echo "$LINE" | grep -q "Correct"; then
                SCORE_TALLY=$(($SCORE_TALLY+1))
            fi
        done < quiz_results/${student_attempts_array[$i]}
    done

    local AVG_SCORE=$(($SCORE_TALLY/${#student_attempts_array[@]}))

    echo ""
    echo "Student Name: $CHOSEN_STUDENT_NAME"
    echo "Avg. Score: $AVG_SCORE/20"
    echo ""

    read -p "Return to main menu? (y/n):" CHOICE

    if [[ "$CHOICE" == "y" || "$CHOICE" == "Y" ]]; then
        echo ""
        teacher_menu
    else
        manage_users
    fi

    manage_users

}

teacher_menu()
{
    echo "----------------"
    echo "Teacher Menu"
    echo "----------------"
    echo "1. View Student Quiz Attempts"
    echo "2. Manage Users & View Student Stats"
    echo "3. Log Out"
    echo "4. Exit"
    echo "----------------"
    read MENU_CHOICE

    case $MENU_CHOICE in 
        1)
            view_student_quiz_results
            ;;
        2)
            manage_users
            ;;
        3)
            logout
            ;;
        4)
            echo "Exiting program...Bye bye"
            exit 0 # exiting program 
            ;;
        *)
            echo "Invalid student option. Please enter an option "
            echo ""
            ;;
    esac


}

student_menu()
{
    echo "----------------"
    echo "Student Menu"
    echo "----------------"

    echo "-----------------"
    echo "1. To Learn Tables"
    echo "2. To Take Quiz"
    echo "3. Log Out"
    echo "4 Quit the program"
    echo "------------------"
    read MENU_CHOICE

    case $MENU_CHOICE in 
        1)
            display_learn_tables_menu
            ;;
        2)
            run_quiz
            ;;
        3)
            logout
            ;;
        4)
            echo "Exiting program...Bye bye"
            exit 0 # exiting program 
            ;;
        *)
            echo "Invalid student option. Please enter an option "
            echo ""
            ;;    
    esac
}

logout()
{
    unset LOGGED_IN_USER
    unset USERDETAILS
    unset teachers_list_of_students

    menu
}


display_learn_tables_menu()
{
    echo ""
    echo "-------------"
    echo "Learn Tables"
    echo "-------------"

    echo "What arithmetic operation do you want to use?: "
    echo "-----------------------------------------------"
    echo "1. Addition"
    echo "2. Subtraction"
    echo "3. Multiplication"
    echo "4. Division"
    echo "-----------------------------------------------"
    read OPERATOR

    learn_tables "$OPERATOR"

}

learn_tables()
{ 
    until ["$1" -lt 1 -a "$1" -gt 4 ]
    do
	    case "$1" in
		    1)
			    echo "Addition"
		            echo "--------"
			    echo "Enter the number for times table: "
			    read NUM

			    
			    for ((i=0; i<=12; i++))
			    do
				    until [ $ANSWER -eq $(($NUM+i)) ]
				    do
					    echo "What is $NUM + $i?:	"
				    	    read ANSWER
					    
					    if [ $ANSWER -eq $(($NUM+$i)) ]
					    then
						    echo "Correct answer!"
				            else
						    echo "Incorrect. Please try again"
				            fi
				    done

			    done
			    display_learn_tables_menu
			    ;;
	            2)
			    echo "Subtraction"
			    echo "--------"
			    echo "Enter the number for times table: "
                            read NUM

                            for ((i=0; i<=12; i++))
                            do
				    until [ $ANSWER -eq $(($NUM-i)) ]
                                    do
                                            echo "What is $NUM - $i?:   "
                                            read ANSWER

                                            if [ $ANSWER -eq $(($NUM-$i)) ]
                                            then
                                                    echo "Correct answer!"
                                            else
                                                    echo "Incorrect. Please try again"
                                            fi
                                    done

                            done
			    display_learn_tables_menu
			    ;;
		    3)

                            echo "Multiplication"
                            echo "--------"
			    echo "Enter the number for times table: "
                            read NUM

                            for ((i=0; i<=12; i++))
                            do
				    until [ $ANSWER -eq $(($NUM*i)) ]
                                    do
                                            echo "What is $NUM x $i?:   "
                                            read ANSWER

                                            if [ $ANSWER -eq $(($NUM*$i)) ]
                                            then
                                                    echo "Correct answer!"
                                            else
                                                    echo "Incorrect. Please try again"
                                            fi
                                    done

                            done
			    display_learn_tables_menu
                            ;;

                    4)
                            echo "Division"
                            echo "--------"
			    echo "Enter the number for times table: "
                            read NUM

                            for ((i=0; i<=12; i++))
                            do
				    until [ $ANSWER -eq $(($NUM / $i)) ]
                                    do
                                            echo "What is $NUM / $i?:   "
                                            read ANSWER

                                            if [ $ANSWER -eq $(($NUM / $i)) ]
                                            then
                                                    echo "Correct answer!"
                                            else
                                                    echo "Incorrect. Please try again"
                                            fi
                                    done

                            done
			    display_learn_tables_menu
                            ;;

		    *)
			    echo ""
			    ;;
	    esac
    done

}


run_quiz()
{
    # Make quiz results directory if not present
    if [[ -d quiz_results ]]; then
        echo ""
    else
        mkdir quiz_results
    fi


    local file=$FIRSTNAME"-"$(date "+%Y%m%d%H%M%S")"-"$(((RANDOM%999+1)))".txt" # Using text file instead of csv for readability
    local LIVES=3 # 3 lives at the start of every quiz
    local counter=0 # for tracking number of consecutive wrong answers, resets after quiz

    echo ""
    echo "----------------"
    echo "TAKE QUIZ!!!"
    echo "-----------------"
    echo ""
    echo "Enter a number -->"
    read NUMBER

    for ((i=0; i<$NUM_QUESTIONS; i++)) # ONE QUESTION FOR EACH ARITHMETIC OPERATION FOR NOW.....
    # can increase this number from 5 to 20 once function is finished
    do
        random_num=$(($RANDOM % 12))
        ans=0

        op=$(($RANDOM % 4))

        if [ $op -eq 1 -o $op -eq 0 ]
        then
            ans=$((NUMBER + $random_num))
            op="+"
        elif [ $op -eq 2 ]
        then    
            ans=$((NUMBER - $random_num))
            op="-"
        elif [ $op -eq 3 ]
        then
            ans=$((NUMBER * $random_num))
            op="x"
        elif [ $op -eq 4 ]
        then
            ans=$((NUMBER / $random_num))
            op="/"
        else
            echo "Error"
        fi

        echo "Question ($((i+1))): What is $NUMBER $op $random_num ?: "
        read USER_ANSWER

        if [ $USER_ANSWER -eq 999 ]
        then
            echo "Exiting quiz..."
            menu
        fi

        if [ $USER_ANSWER -eq $ans ]
        then
            echo "Correct answer!"

            counter=0 # reseting the counter as answer is correct

            # Write results to a file (txt)
            echo "$NUMBER $op $random_num = $ans --> User answer: $USER_ANSWER (Correct)" >> quiz_results/$file

        else
            echo "Incorrect."

            counter=$(($counter+1))

            echo "$NUMBER $op $random_num = $ans --> User answer: $USER_ANSWER (Wrong)" >> quiz_results/$file

            if [ $counter -eq 2 ] || [ $counter -eq 4 ] || [ $counter -eq 6 ]
            then
                LIVES=$(($LIVES-1))

                if [ "$LIVES" -eq 0 ]
                then
                    echo "You have no lives left. Quiz is now over."
                    read -p "Do you want to start a new quiz? (y/n):  " RESPONSE

                    if [ "$RESPONSE" == 'y' ] || [ "$RESPONSE" == 'Y' ]
                    then
                        run_quiz
                    else
                        # back to menu code....
                        exit 0
                    fi
                fi

                echo "You have $LIVES lives remaining."
            fi
        fi

    done

    echo "Quiz finished!"
}

menu # run menu at startup


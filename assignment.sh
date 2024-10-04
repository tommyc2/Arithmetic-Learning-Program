#!/bin/bash

# Bash Assignment 1
# Arithmetic Learning App
# with Teacher/Student Login Program
# ---------------------------------
# by Tommy Condon - 20101841
# github.com/tommyc2

# Random number code source: https://www.baeldung.com/linux/bash-draw-random-ints

# Create CSV file for storing student results -- TO COMPELTE FULLY
touch QUIZ_RESULTS.csv

NUM_QUESTIONS=20
USERS_FILE="users.csv"


menu()
{

    echo """
    ----------------
    Login
    ---------------
    1. Teacher Login
    2. Student Login
    ---------------
    -->  """
    read LEVEL

    if [ $LEVEL -eq 1 ] # Login as teacher
    then
        echo "---------------------"
        echo "Teachers Menu Options"
        echo "---------------------"

        teacher_login

    elif [ $LEVEL -eq 2 ] # Student Login
    then
        student_login # Calling student menu function
    else
        echo -e "Invalid Choice in Menu Function.\n\r"
        menu # function calling itself to start again
    fi
}

student_login()
{
    read -p "Enter Username: " USERNAME
    read -p "Enter Password: " PASSWORD

    echo "Authenicating Login...."

    # TODO ----> check regex here 

    if grep -q "$USERNAME," "$USERS_FILE"
    then
        if grep -q "$USERNAME,$PASSWORD," "$USERS_FILE"
        then
            echo "Hello $USERNAME!"
            echo "-----------------"

            # TODO: Make directories and stuff here for each student

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
    echo " TO DO"
}

student_menu()
{
    echo "----------------"
    echo "Student Menu"
    echo "----------------"

    until [ $MENU_CHOICE -ge 1 ] && [ $MENU_CHOICE -le 3 ]
    do
        echo "-----------------"
        echo "1. To Learn Tables"
        echo "2. To Take Quiz"
        echo "3. To Exit Program"
        echo "------------------"
        read MENU_CHOICE

        if [ $MENU_CHOICE -lt 1 -o $MENU_CHOICE -gt 3 ]
        then
            echo "Please enter an option in the range 1 to 3 only!"
            echo ""
        fi
    done

    case $MENU_CHOICE in 
        1)
            display_learn_tables_menu
            ;;
        2)
            run_quiz
            ;;
        3)
            echo "Exiting program...Bye bye"
            exit 0 # exiting program 
            ;;
        *)
        echo "Invalid student option. Please enter an option "
        echo ""    
    esac
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
    local LIVES=3 # 3 lives at the start of every quiz
    local counter=0 # for tracking number of consecutive wrong answers, resets after quiz

    echo ""
    echo "----------------"
    echo "TAKE QUIZ!!!"
    echo "-----------------"
    echo ""
    echo "Enter a number -->"
    read NUMBER

    for ((i=0; i<20; i++)) # ONE QUESTION FOR EACH ARITHMETIC OPERATION FOR NOW.....
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

        # To complete properly, need clarification on what 'exit quiz' refers to...
        if [ $USER_ANSWER -eq 999 ]
        then
            echo "Exiting quiz..."
            menu
        fi

        if [ $USER_ANSWER -eq $ans ]
        then
            echo "Correct answer!"

            counter=0 # reseting the counter as answer is correct

            # Write results to a file (CSV)
            echo "$NUMBER,$op,$random_num,$USER_ANSWER,$ans,1" >> QUIZ_RESULTS.csv

            #j=0

            #QUIZ_RESULTS["$i,$j"]=$NUMBER
            #QUIZ_RESULTS["$i,$((j+1))"]=$op
            #QUIZ_RESULTS["$i,$((j+2))"]=$random_num
            #QUIZ_RESULTS["$i,$((j+3))"]=$USER_ANSWER
            #QUIZ_RESULTS["$i,$((j+4))"]=$ans
            #QUIZ_RESULTS["$i,$((j+5))"]=1

            # check if populated
            #for((i=0; i<20; i++))
            #do
            #    for((j=0;j<6;j++))
            #    do
            #        #echo -n "${QUIZ_RESULTS["$i,$j"]}, "
            #    done
            #done

        else
            echo "Incorrect."

            counter=$(($counter+1))
            echo "Counter value: $counter"

            echo "$NUMBER,$op,$random_num,$USER_ANSWER,$ans,0" >> QUIZ_RESULTS.csv

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


            #QUIZ_RESULTS["$i,$j"]=$NUMBER
            #QUIZ_RESULTS["$i,$((j+1))"]=$op
            #QUIZ_RESULTS["$i,$((j+2))"]=$random_num
            #QUIZ_RESULTS["$i,$((j+3))"]=$USER_ANSWER
            #QUIZ_RESULTS["$i,$((j+4))"]=$ans
            #QUIZ_RESULTS["$i,$((j+5))"]=1
        fi

    done

    echo "Quiz finished!"
}

menu # run menu at startup



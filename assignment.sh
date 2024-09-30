#!/bin/bash

# Bash Assignment 1
# Arithmetic Learning App
# with Teacher/Student Login Program
# ---------------------------------
# by Tommy Condon - 20101841
# github.com/tommyc2

# Random number code source: https://www.baeldung.com/linux/bash-draw-random-ints

# Create CSV file for storing student results
touch QUIZ_RESULTS.csv


LEVEL=2
MENU_CHOICE=0
NUM_QUESTIONS=20

#declare -a QUIZ_RESULTS=()


menu()
{
    MENU_CHOICE=0

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

        # Until loop here with teacher options...
    elif [ $LEVEL -eq 2 ] # Student Login
    then

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


    else
        echo "Invalid Choice in Menu Function"
	echo ""
    fi
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
				    until [ $ANSWER -eq $(($NUM/i)) ]
                                    do
                                            echo "What is $NUM / $i?:   "
                                            read ANSWER

                                            if [ $ANSWER -eq $(($NUM/$i)) ]
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

        if [ $USER_ANSWER -eq $ans ]
        then
            echo "Correct answer!"

            # Write results to a file (CSV)
            echo "$NUMBER,$op,$random_num,$USER_ANSWER,$ans,1\n" >> QUIZ_RESULTS.csv

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

            echo "$NUMBER,$op,$random_num,$USER_ANSWER,$ans,0" >> QUIZ_RESULTS.csv

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



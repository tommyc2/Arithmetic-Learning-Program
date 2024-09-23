#!/bin/bash

# Bash Assignment 1 - Teacher/Student Login Program
# Tommy Condon - 20101841
# github.com/tommyc2

LEVEL=2
MENU_CHOICE=0
NUM_QUESTIONS=20

menu()
{
    MENU_CHOICE=0

    echo """
    ----------------
    Login
    ---------------
    1. Teacher
    2. Student
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
            take_quiz
            ;;
        3)
            echo "Exiting program..."
            sleep 2
            exit 1
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
    until [$1 -lt 1 -a $1 -gt 4 ]
    do
	    case $1 in
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


take_quiz()
{
    echo ""
    echo "----------------"
    echo "TAKE QUIZ SECTION"
    echo "-----------------"

    for ((i=0; i <= $NUM_QUESTIONS; i++))
    do
	    echo "Question $i:	"
    done
}

menu

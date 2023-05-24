import random


def run_game():
    code = []
    while (len(code)<4):
        not_duplicate = random.randint(1, 8)
        if (not_duplicate not in code):
            code.append(not_duplicate)

    print("4-digit Code has been set. Digits in range 1 to 8. You have 12 turns to break it.")

    number_of_turns = 12
    while number_of_turns > 0:
        user_input = input("Input 4 digit code: ")

        while user_input.isdigit == False or len(user_input) != 4:
            print("Please enter exactly 4 digits.")
            user_input = input("Input 4 digit code: ")
        correct_place = 0
        not_correct_place = 0

        for count in range(0, len(code)):
            if int(user_input[count]) == code[count]:
                correct_place += 1
            elif int(user_input[count]) in code:
                not_correct_place += 1
            
        
        print("Number of correct digits in correct place:     " + str(correct_place))
        print("Number of correct digits not in correct place: " + str(not_correct_place))
        if correct_place == 4:
            print("Congratulations! You are a codebreaker!" )
            print("The code was: " ,end="")
            for i in range(len(code)):
                print(code[i], end="")
            break
        elif number_of_turns > 1:
            number_of_turns -= 1

            print("Turns left: " + str(number_of_turns))
        elif number_of_turns == 1:
            print("The code was: " ,end="")
            for i in range(len(code)):
                print(code[i], end="")
            break


if __name__ == "__main__":
    run_game()

package za.co.wethinkcode.mastermind;

import java.io.InputStream;
import java.util.Scanner;

public class Player {
    private final Scanner inputScanner;

    public Player() {
        this.inputScanner = new Scanner(System.in);
    }

    public Player(InputStream inputStream) {
        this.inputScanner = new Scanner(inputStream);
    }

    /**
     * Gets a guess from user via text console.
     * This must prompt the user to re-enter a guess until a valid 4-digit string is entered, or until the user enters `exit` or `quit`.
     *
     * @return the value entered by the user
     */
    public String getGuess() {

        boolean codeValidity = false; //creating a boolean that checks that the code is valid
        char[] code = new char[4]; // allows only a maximum of 4 characters

        System.out.println("Input 4 digit code:"); // Print statement
        String userGuess; // Creating a String
        userGuess = inputScanner.nextLine(); // Allowing user input


        // creating a while loop
        while (codeValidity == false) {
            if (userGuess.equals("quit") || userGuess.equals("exit")) {    // if user input is exit or quit the program ends
                break;
            }

            if (userGuess.length() == 4) {
                for (int i = 0; i < userGuess.length(); i++) {
                    code[i] = userGuess.charAt(i);
                }
                for (int i = 0; i < userGuess.length(); i++) {
                    if (Character.isDigit(code[i])) {
                        if (1 <= Integer.parseInt(String.valueOf(code[i])) &&   // taking user input and converting it to an integer
                                8 >= Integer.parseInt(String.valueOf(code[i]))) {
                            codeValidity = true;
                        } else {
                            codeValidity = false;
                            break;
                        }
                    } else {
                        codeValidity = false;
                        break;
                    }
                }
            } else if (userGuess.isBlank()) {  // if user does not input a char
                codeValidity = false;
            } else {
                codeValidity = false;
            }


            // if user does enters invalid answer, the following will prompt
            if (codeValidity == false) {
                System.out.println("Please enter exactly 4 digits (each from 1 to 8).");
                System.out.println("Input 4 digit code:");
                userGuess = inputScanner.nextLine();
            }
        }
        return userGuess;
    }
}

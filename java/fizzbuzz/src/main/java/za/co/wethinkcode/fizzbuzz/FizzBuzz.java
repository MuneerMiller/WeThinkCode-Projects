package za.co.wethinkcode.fizzbuzz;

import java.util.ArrayList;

public class FizzBuzz {
    public String checkNumber(int number) {
        boolean divisibleBy3 = number % 3 == 0;
        boolean divisibleBy5 = number % 5 == 0;
        boolean divisibleBy15 = number % 15 == 0;

        if ( divisibleBy15) {
            return ("FizzBuzz");
        } else if (divisibleBy5){
            return ("Buzz");
        } else if ( divisibleBy3){
            return ("Fizz");
        }
        return String.valueOf(number);
    }

    public String countTo(int number){
        int pro = 1;
        ArrayList<String> MyList = new ArrayList<>();
        while (pro < number + 1){
            MyList.add(String.valueOf(checkNumber(pro)));
            pro++;
        }
        return String.valueOf(MyList);
    }
}

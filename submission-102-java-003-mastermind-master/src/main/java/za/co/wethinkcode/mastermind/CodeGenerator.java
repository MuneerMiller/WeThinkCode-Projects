package za.co.wethinkcode.mastermind;

import java.util.Random;

public class CodeGenerator {
    private final Random random;

    public CodeGenerator(){
        this.random = new Random();
    }

    public CodeGenerator(Random random){
        this.random = random;
    }

    /**
     * Generates a random 4 digit code, using this.random, where each digit is in the range 1 to 8 only.
     * Duplicated digits are allowed.
     * @return the generated 4-digit code
     */
    public String generateCode(){
        //TODO: implement using this.random
        int pos1 = 1 + random.nextInt(8);
        int pos2 = 1 + random.nextInt(8);
        int pos3 = 1 + random.nextInt(8);
        int pos4 = 1 + random.nextInt(8);

        String code = Integer.toString(pos1)+Integer.toString(pos2)+Integer.toString(pos3)+Integer.toString(pos4);
//        System.out.println(code);
        return code;
    }
}

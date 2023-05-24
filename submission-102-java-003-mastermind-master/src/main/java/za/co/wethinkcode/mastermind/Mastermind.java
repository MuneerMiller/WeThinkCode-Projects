package za.co.wethinkcode.mastermind;

public class Mastermind {
    private final String code;
    private final Player player;

    public Mastermind(CodeGenerator generator, Player player){
        this.code = generator.generateCode();
        this.player = player;
    }
    public Mastermind(){
        this(new CodeGenerator(), new Player());
    }

    public void runGame(){
        //TODO: implement the main run loop logic
        System.out.println("4-digit Code has been set. Digits in range 1 to 8. You have 12 turns to break it.");
        int chances = 12;
        int guesses = 0;

        String generateCode = code;
        while(guesses != 12){
            int correctPlace = 0;
            int incorrectPlace = 0;
            String playGame = player.getGuess();

            for(int i = 0 ; i < 4; i++){
                char x = generateCode.charAt(i);

                if(playGame.charAt(i) == generateCode.charAt(i)){
                    correctPlace++;
                }else if(playGame.contains(String.valueOf(x))){
                    incorrectPlace++;
                }
            }
            if(correctPlace == 4) {
                System.out.println("Number of correct digits in correct place: " + correctPlace);
                System.out.println("Number of correct digits not in correct place: " + incorrectPlace);
                System.out.println("Congratulations! You are a codebreaker!");
                System.out.println("The code was: " + generateCode);
                break;
            }else{
                System.out.println("Number of correct digits in correct place: " + correctPlace);
                System.out.println("Number of correct digits not in correct place: " + incorrectPlace);
            }
            int chancesLeft = (chances - 1) - guesses;
            if (chancesLeft == 0){
                System.out.println("No more turns left.");
                System.out.println("The code was: " + generateCode);
            }else{
                System.out.println("Turns left: " + ((chances - 1) - guesses));
            }
            guesses++;
        }
    }

    public static void main(String[] args){
        Mastermind game = new Mastermind();
        game.runGame();
//        Player input = new Player();
//        input.getGuess();
    }
}

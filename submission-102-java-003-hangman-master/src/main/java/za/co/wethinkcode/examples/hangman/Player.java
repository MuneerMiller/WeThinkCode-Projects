package za.co.wethinkcode.examples.hangman;

import java.io.InputStream;
import java.util.Scanner;

public class Player {
    private int chances = 5;
    private final Scanner scanner;
    private boolean quit = false;


    public int getChances() {
        return chances;
    }


    public void lostChance() {
        if (!this.hasNoChances()) {
            this.chances--;
        }
    }


    public boolean hasNoChances() {
        return this.getChances() == 0;
    }



    public Player() {
        this.scanner = new Scanner(System.in);
    }


    public Player(InputStream in) {
        this.scanner = new Scanner(in);
    }


    public String getWordsFile(InputStream inputStream) {
        Scanner sc = new Scanner(inputStream);
        String filename = sc.nextLine();
        return filename;
    }


    public String getWordsFile() {
        String filename = scanner.nextLine();
        return filename.isBlank() ? "short_words.txt" : filename;
    }


    public String getGuess() {
        String text = scanner.nextLine();
        this.quit = text.equalsIgnoreCase("exit") ||text.equalsIgnoreCase("quit") ;
        return text;
    }


    public boolean wantsToQuit() {
        return this.quit;
    }
}


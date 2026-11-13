package za.co.wethinkcode.examples.hangman;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Random;

// tag::hangman-class[]
public class Hangman {

    public static void main(String[] args) throws IOException {

        Player player = new Player();
        Answer wordToGuess = pickWords(player);
        Answer currentAnswer = start(player, wordToGuess);
        String message = run(player, wordToGuess, currentAnswer);
        System.out.println(message);
    }


    private static String run(Player player, Answer wordToGuess, Answer currentAnswer) {
        while (!currentAnswer.equals(wordToGuess)) {                                         //<9>
            String guess = player.getGuess();                                                     //<10>
            if (player.wantsToQuit()) {
                return "Bye!";
            }
            char guessedLetter = guess.charAt(0);
            if (wordToGuess.hasLetter(guessedLetter)
                    && !currentAnswer.hasLetter(guessedLetter)) {
                currentAnswer = wordToGuess.getHint(currentAnswer, guessedLetter);
                System.out.println(currentAnswer);
            } else {                                                                                    //<13>
                // tag::use-numberGuesses[]
                player.lostChance();
                System.out.println("Wrong! Number of guesses left: " + player.getChances());
                if (player.hasNoChances()) {
                    return  "Sorry, you are out of guesses. The word was: " + wordToGuess;
                }
                // end::use-numberGuesses[]
            }
        }


        if (currentAnswer.equals(wordToGuess)) {                                             //<14>
            return "That is correct! You escaped the noose .. this time.";
        }
        return currentAnswer.toString();
    }


    private static Answer pickWords(Player player) throws IOException {
        Random random = new Random();
        System.out.println("Words file? [leave empty to use short_words.txt]");
        String fileName = player.getWordsFile();                                                      // <2>

        List<String> words = Files.readAllLines(Path.of(fileName));                                     //<3>

        int randomIndex = random.nextInt(words.size());                                                 //<4>
        String randomWord = words.get(randomIndex).trim();
        return  new Answer(randomWord);
        }


    private static Answer start(Player player, Answer wordToGuess) {
        Answer currentAnswer = wordToGuess.generateRandomHint();
        System.out.println("Guess the word: " + currentAnswer);
        return currentAnswer;
    }
}


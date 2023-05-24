package za.co.wethinkcode.examples.hangman;

import org.junit.jupiter.api.Test;
import za.co.wethinkcode.examples.hangman.Hangman;


import java.io.*;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.fail;

// tag::header[]
class HangmanTest {
    // end::header[]
    // tag::simulate[]
    private void simulateGame(String simulatedUserInput, String expectedLastLine) {
        InputStream simulatedInputStream = new ByteArrayInputStream(simulatedUserInput.getBytes());
        System.setIn(simulatedInputStream);

        ByteArrayOutputStream outputStreamCaptor = new ByteArrayOutputStream();
        System.setOut(new PrintStream(outputStreamCaptor));

        try {
            Hangman.main(new String[]{});
        } catch (IOException e) {
            fail("Not expecting an exception.");
        }

        String[] linesOutput = outputStreamCaptor.toString().split("\n");
        String lastLine = linesOutput[linesOutput.length - 1];
        assertEquals(expectedLastLine, lastLine);
    }
    // end::simulate[]
    // tag::test-win[]
    @Test
    public void shouldWinTheGame() {
        String simulatedUserInput = "oneword.txt\nt\ne\ns\n";
        String expectedOutput = "That is correct! You escaped the noose .. this time.";
        simulateGame(simulatedUserInput, expectedOutput);
    }

    // end::test-win[]
    // tag::test-lose[]
    @Test
    public void shouldLoseTheGame() {
        String simulatedUserInput = "oneword.txt\na\nb\nc\nd\nx\n";                                     //<1>
        String expectedOutput = "Sorry, you are out of guesses. The word was: test";                    //<2>
        simulateGame(simulatedUserInput, expectedOutput);                                               //<3>
    }
    // end::test-lose[]
// tag::footer[]
}
// end::footer[]

# Hangman (Java)

Hangman rebuilt in Java with three classes: `Player` tracks chances and reads guesses, `Answer` holds the word and builds hints, and `Hangman` runs the game.

## What it practises

- Encapsulation: each class owns its own data
- Testing with JUnit 5 and Mockito
- Reading input from an `InputStream` so it can be tested

## Build, test and run

You need Java 11 and Maven. From this folder:

```bash
mvn test
```

```bash
mvn compile exec:java
```

To open it in IntelliJ IDEA, choose *File → New → Project from Existing Sources…*, select this folder and pick *Maven*.

---

Part of my [WeThinkCode_ coursework](../../README.md). The brief, the skeleton code and the tests in `src/test/java/za/co/wethinkcode/lms` were provided by WeThinkCode_; the solution and the other tests are mine.

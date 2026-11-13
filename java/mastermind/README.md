# Mastermind (Java)

Mastermind rebuilt in Java. `CodeGenerator` makes the secret code, `Player` reads guesses, and `Mastermind` runs the game. The random number generator is passed in, so tests can fix the code.

## What it practises

- Encapsulation and constructor injection
- Mocking `Random` with Mockito to make tests predictable

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

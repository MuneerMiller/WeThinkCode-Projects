# Hangman: Loops

The full game of Hangman. Guess letters one at a time with 5 wrong guesses allowed, while the hangman figure is drawn step by step. Type `quit` or `exit` to stop.

## What it practises

- `while` loops that run until you win, lose or quit
- Tracking state between turns
- Drawing ASCII art for each stage

## Run it

From this folder:

```bash
python3 hangman.py
```

Example:

```
Guess the word: f___
Guess the missing letter: a
Wrong! Number of guesses left: 4

/----
|
|
|
|
_______
```

## Test it

```bash
python3 -m unittest
```

---

Part of my [WeThinkCode_ coursework](../../README.md). The problem brief and the tests in `tests/` were provided by WeThinkCode_; the solution is mine.

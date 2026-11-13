<div align="center">

# WeThinkCode_ Projects

**My work from the [WeThinkCode_](https://www.wethinkcode.co.za/) software engineering programme (2020–2022), and the app that grew out of it.**

![Python](https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=white)
![Java](https://img.shields.io/badge/Java-ED8B00?logo=openjdk&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)

</div>

WeThinkCode_ is a peer-led programme where you learn by building, in Agile teams, with every problem checked by unit tests. I finished it with a **National Certificate: IT Systems Development (NQF 5)**. This repo keeps my solutions together, from the first Python exercises to my final project.

## ⭐ Featured: Elderly Care

**[`elderly_app-master/`](elderly_app-master)** · Flutter · Dart · Android · iOS · Web

A calm health companion for older people: one-tap SOS, medicine reminders with read-aloud, a blood pressure tracker, a medical ID, nearby hospitals and a PIN or fingerprint lock.

It started as my solo final project for the programme. I've since rebuilt it from the ground up so it runs on Android, iOS and the web from one codebase, with AES-256 encrypted data, four languages (English, Afrikaans, isiZulu and isiXhosa) and automated tests that CI runs on every change. It's prepared for release on the App Store and Google Play.

**[▶ Try the live demo](https://muneermiller.github.io/WeThinkCode-Projects/demo.html)** · [Read the full README](elderly_app-master/README.md)

## 🐍 Python coursework

Each folder has the problem's own README, my solution and the unit tests it was marked against.

| Project | What it does | Concepts |
| --- | --- | --- |
| [wtc-basics](python/wtc-basics) | First steps: getting a program to run and pass its tests | Functions, testing |
| [hangman](python/hangman) | Picks a random word from a file and asks you to fill in a missing letter | Files, random, input |
| [hangman-conditionals](python/hangman-conditionals) | Checks each guess and reacts to right and wrong answers | Conditionals |
| [hangman-loops](python/hangman-loops) | The full game, with limited guesses and a hangman figure drawn as you lose | Loops |
| [pyramids](python/pyramids) | Draws pyramids, squares, triangles, diamonds and rhombuses, solid or outlined | Nested loops |
| [word-processor](python/word-processor) | Splits text into words and counts lengths, letters and the most used character | Lists, dictionaries, comprehensions |
| [bug-fixer](python/bug-fixer) | Finds and fixes the bugs in a "troll hunter" that scans source files | Debugging, reading code |
| [course-outline](python/course-outline) | Models a course's topics, problems and their status with classes | Classes, OOP |
| [mastermind](python/mastermind) | The code-breaking game: guess a 4-digit code from hints | Game logic |
| [mastermind-functions](python/mastermind-functions) | Mastermind refactored into small, testable functions | Decomposition |
| [mastermind-returns](python/mastermind-returns) | Mastermind with functions that return values and are tested on their own | Return values, unit tests |
| [toy-robot](python/toy-robot) | A robot that takes commands and moves around a grid | Command parsing |
| [toy-robot-3](python/toy-robot-3) | Keeps a command history and can replay earlier moves | State, refactoring |
| [toy-robot-4-obstacles](python/toy-robot-4-obstacles) | Random obstacles, with a text world and a turtle-graphics world | Modules, packages |
| [toy-robot-5-maze](python/toy-robot-5-maze) | Swaps random obstacles for a generated maze | Algorithms, imports |
| [recursion](python/recursion) | Minimum, sum and every possible string of a given length, all without loops | Recursion |

## ☕ Java coursework

| Project | What it does | Concepts |
| --- | --- | --- |
| [fizzbuzz](java/fizzbuzz) | The classic FizzBuzz, as a first Java and Maven project | Java basics, Maven |
| [hangman](java/hangman) | Hangman rebuilt in Java with `Player` and `Answer` classes | Encapsulation, JUnit 5 |
| [mastermind](java/mastermind) | Mastermind rebuilt in Java | Encapsulation, JUnit 5 |

## Running the coursework

Python projects, from inside a project folder:

```bash
python3 -m unittest
```

Java projects, from inside a project folder (needs Maven):

```bash
mvn test
```

---

<p align="center">
  More about me at <a href="https://muneermiller.github.io/">muneermiller.github.io</a>
</p>

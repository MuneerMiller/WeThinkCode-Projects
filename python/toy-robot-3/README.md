# Toy Robot 3: Commands and Replay

An interactive robot you name and then command: `forward`, `back`, `left`, `right` and `sprint`, inside a fenced area of x −100 to 100 and y −200 to 200. It remembers every movement command and can `replay` them, `silent` or `reversed`, all of them or a range such as `replay 3` or `replay 4-2`.

## What it practises

- Parsing commands and arguments
- Keeping a command history
- Refactoring a growing program into many small functions

## Run it

From this folder:

```bash
python3 robot.py
```

Example:

```
What do you want to name your robot? HAL
HAL: Hello kiddo!
HAL: What must I do next? forward 10
 > HAL moved forward by 10 steps.
 > HAL now at position (0,10).
HAL: What must I do next? replay
 > HAL moved forward by 10 steps.
 > HAL now at position (0,20).
 > HAL replayed 1 commands.
 > HAL now at position (0,20).
HAL: What must I do next? off
HAL: Shutting down..
```

## Test it

```bash
python3 -m unittest
```

---

Part of my [WeThinkCode_ coursework](../../README.md). The problem brief and the tests in `tests/` were provided by WeThinkCode_; the solution is mine.

# Bug Fixer: Troll Hunter

I was given a buggy "troll hunter" that scans the `.txt` and `.csv` files in a folder, replaces *goblin* with *elf* and *hobgoblin* with *orc*, and raises a custom exception when it finds a troll. The job was to find and fix the bugs until the tests passed.

## What it practises

- Reading and debugging someone else's code
- Custom exceptions
- Walking a folder of files with `os`

## Run it

From this folder:

```bash
python3 -c "import troll_hunter as t; print(t.troll_check('A goblin and a hobgoblin walk into a bar.'))"
```

```
A elf and a orc walk into a bar.
```

## Test it

```bash
python3 -m unittest
```

---

Part of my [WeThinkCode_ coursework](../../README.md). The problem brief and the tests in `tests/` were provided by WeThinkCode_; the solution is mine.

import random
import unittest
from io import StringIO
import sys
import io
from unittest.mock import patch
from robot import *
from maze import obstacles


class MyTestCase(unittest.TestCase):
    @patch("sys.stdin", StringIO('Joe\nforward 10\nforward 5\nreplay\noff\n'))
    def test_replay(self):
        obstacles.random.randint = lambda a, b: 0
        sys.stdout = io.StringIO()
        robot_start()
        self.assertEqual(sys.stdout.getvalue(), """What do you want to name your robot? Joe: Hello kiddo!
Joe: What must I do next?  > Joe moved forward by 10 steps.
 > Joe now at position (0,10).
Joe: What must I do next?  > Joe moved forward by 5 steps.
 > Joe now at position (0,15).
Joe: What must I do next?  > Joe moved forward by 10 steps.
 > Joe now at position (0,25).
 > Joe moved forward by 5 steps.
 > Joe now at position (0,30).
 > Joe replayed 2 commands.
 > Joe now at position (0,30).
Joe: What must I do next? Joe: Shutting down..\n""")

    @patch("sys.stdin", StringIO('Joe\nforward 10\nforward 5\nreplay\nreplay\noff\n'))
    def test_step2_replay_twice(self):
        obstacles.random.randint = lambda a, b: 0
        sys.stdout = io.StringIO()
        robot_start()
        self.assertEqual(sys.stdout.getvalue(), """What do you want to name your robot? Joe: Hello kiddo!
Joe: What must I do next?  > Joe moved forward by 10 steps.
 > Joe now at position (0,10).
Joe: What must I do next?  > Joe moved forward by 5 steps.
 > Joe now at position (0,15).
Joe: What must I do next?  > Joe moved forward by 10 steps.
 > Joe now at position (0,25).
 > Joe moved forward by 5 steps.
 > Joe now at position (0,30).
 > Joe replayed 2 commands.
 > Joe now at position (0,30).
Joe: What must I do next?  > Joe moved forward by 10 steps.
 > Joe now at position (0,40).
 > Joe moved forward by 5 steps.
 > Joe now at position (0,45).
 > Joe replayed 2 commands.
 > Joe now at position (0,45).
Joe: What must I do next? Joe: Shutting down..\n""")

    @patch("sys.stdin", StringIO('Joe\nforward 10\nforward 5\nreplay silent\noff\n'))
    def test_step3_replay_silent(self):
        obstacles.random.randint = lambda a, b: 0
        sys.stdout = io.StringIO()
        robot_start()
        self.assertEqual(sys.stdout.getvalue(), """What do you want to name your robot? Joe: Hello kiddo!
Joe: What must I do next?  > Joe moved forward by 10 steps.
 > Joe now at position (0,10).
Joe: What must I do next?  > Joe moved forward by 5 steps.
 > Joe now at position (0,15).
Joe: What must I do next?  > Joe replayed 2 commands silently.
 > Joe now at position (0,30).
Joe: What must I do next? Joe: Shutting down..\n""")

    @patch("sys.stdin", StringIO('Joe\nforward 10\nforward 5\nREPLAY SILENT\noff\n'))
    def test_step3_replay_silent_upper(self):
        obstacles.random.randint = lambda a, b: 0
        sys.stdout = io.StringIO()
        robot_start()
        self.assertEqual(sys.stdout.getvalue(), """What do you want to name your robot? Joe: Hello kiddo!
Joe: What must I do next?  > Joe moved forward by 10 steps.
 > Joe now at position (0,10).
Joe: What must I do next?  > Joe moved forward by 5 steps.
 > Joe now at position (0,15).
Joe: What must I do next?  > Joe replayed 2 commands silently.
 > Joe now at position (0,30).
Joe: What must I do next? Joe: Shutting down..\n""")


    @patch("sys.stdin", StringIO('Joe\nforward 10\nforward 5\nreplay reversed\noff\n'))
    def test_step4_replay_reversed(self):
        obstacles.random.randint = lambda a, b: 0
        sys.stdout = io.StringIO()
        robot_start()
        self.assertEqual(sys.stdout.getvalue(), """What do you want to name your robot? Joe: Hello kiddo!
Joe: What must I do next?  > Joe moved forward by 10 steps.
 > Joe now at position (0,10).
Joe: What must I do next?  > Joe moved forward by 5 steps.
 > Joe now at position (0,15).
Joe: What must I do next?  > Joe moved forward by 5 steps.
 > Joe now at position (0,20).
 > Joe moved forward by 10 steps.
 > Joe now at position (0,30).
 > Joe replayed 2 commands in reverse.
 > Joe now at position (0,30).
Joe: What must I do next? Joe: Shutting down..\n""")

    @patch("sys.stdin", StringIO('Joe\nforward 10\nforward 5\nreplay REVERSED\noff\n'))
    def test_step4_replay_reversed_upper(self):
        obstacles.random.randint = lambda a, b: 0
        sys.stdout = io.StringIO()
        robot_start()
        self.assertEqual(sys.stdout.getvalue(), """What do you want to name your robot? Joe: Hello kiddo!
Joe: What must I do next?  > Joe moved forward by 10 steps.
 > Joe now at position (0,10).
Joe: What must I do next?  > Joe moved forward by 5 steps.
 > Joe now at position (0,15).
Joe: What must I do next?  > Joe moved forward by 5 steps.
 > Joe now at position (0,20).
 > Joe moved forward by 10 steps.
 > Joe now at position (0,30).
 > Joe replayed 2 commands in reverse.
 > Joe now at position (0,30).
Joe: What must I do next? Joe: Shutting down..\n""")

    @patch("sys.stdin", StringIO('Joe\nforward 10\nforward 5\nreplay reversed silent\noff\n'))
    def test_step3_replay_silent_reversed(self):
        obstacles.random.randint = lambda a, b: 0
        sys.stdout = io.StringIO()
        robot_start()
        self.assertEqual(sys.stdout.getvalue(), """What do you want to name your robot? Joe: Hello kiddo!
Joe: What must I do next?  > Joe moved forward by 10 steps.
 > Joe now at position (0,10).
Joe: What must I do next?  > Joe moved forward by 5 steps.
 > Joe now at position (0,15).
Joe: What must I do next?  > Joe replayed 2 commands in reverse silently.
 > Joe now at position (0,30).
Joe: What must I do next? Joe: Shutting down..\n""")

    @patch("sys.stdin", StringIO('Joe\nforward 10\nforward 5\nreplay REVERSED SILENT\noff\n'))
    def test_step3_replay_silent_reversed_upper(self):
        obstacles.random.randint = lambda a, b: 0
        sys.stdout = io.StringIO()
        robot_start()
        self.assertEqual(sys.stdout.getvalue(), """What do you want to name your robot? Joe: Hello kiddo!
Joe: What must I do next?  > Joe moved forward by 10 steps.
 > Joe now at position (0,10).
Joe: What must I do next?  > Joe moved forward by 5 steps.
 > Joe now at position (0,15).
Joe: What must I do next?  > Joe replayed 2 commands in reverse silently.
 > Joe now at position (0,30).
Joe: What must I do next? Joe: Shutting down..\n""")


    @patch("sys.stdin", StringIO('Joe\nforward 3\nforward 2\nforward 1\nreplay 2\noff\n'))
    def test_step6_replay_range_basic(self):
        obstacles.random.randint = lambda a, b: 0
        sys.stdout = io.StringIO()
        robot_start()
        self.assertEqual(sys.stdout.getvalue(), """What do you want to name your robot? Joe: Hello kiddo!
Joe: What must I do next?  > Joe moved forward by 3 steps.
 > Joe now at position (0,3).
Joe: What must I do next?  > Joe moved forward by 2 steps.
 > Joe now at position (0,5).
Joe: What must I do next?  > Joe moved forward by 1 steps.
 > Joe now at position (0,6).
Joe: What must I do next?  > Joe moved forward by 2 steps.
 > Joe now at position (0,8).
 > Joe moved forward by 1 steps.
 > Joe now at position (0,9).
 > Joe replayed 2 commands.
 > Joe now at position (0,9).
Joe: What must I do next? Joe: Shutting down..\n""")

    @patch("sys.stdin", StringIO('Joe\nforward 3\nforward 2\nforward 1\nreplay 3-1\noff\n'))
    def test_step6_replay_range_full(self):
        obstacles.random.randint = lambda a, b: 0
        sys.stdout = io.StringIO()
        robot_start()
        self.assertEqual(sys.stdout.getvalue(), """What do you want to name your robot? Joe: Hello kiddo!
Joe: What must I do next?  > Joe moved forward by 3 steps.
 > Joe now at position (0,3).
Joe: What must I do next?  > Joe moved forward by 2 steps.
 > Joe now at position (0,5).
Joe: What must I do next?  > Joe moved forward by 1 steps.
 > Joe now at position (0,6).
Joe: What must I do next?  > Joe moved forward by 3 steps.
 > Joe now at position (0,9).
 > Joe moved forward by 2 steps.
 > Joe now at position (0,11).
 > Joe replayed 2 commands.
 > Joe now at position (0,11).
Joe: What must I do next? Joe: Shutting down..\n""")


if __name__ == '__main__':
    unittest.main()

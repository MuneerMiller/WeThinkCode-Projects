import unittest
from world.text import world
import sys
import io
from io import StringIO


class MyTestCase(unittest.TestCase):
    def test_list_obstacles(self):
        self.maxDiff = None
        block_list = [(12,95), (-5,85), (-121,-23)]
        sys.stdout = io.StringIO()
        world.list_obstacles(block_list)
        self.assertEqual(sys.stdout.getvalue(), """There are some obstacles:
- At position 12,95 (to 16,99)
- At position -5,85 (to -1,89)
- At position -121,-23 (to -117,-19)
""")

if __name__ == "__main__":
    unittest.main()

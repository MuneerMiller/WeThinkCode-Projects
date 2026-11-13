import unittest
from io import StringIO
import sys
import io
from unittest.mock import patch
import mastermind

class MyTestCase(unittest.TestCase):
    def test_create_code(self):
        for i in range(100):
            code = mastermind.create_code()
            self.assertNotIn(0, code)
            self.assertNotIn(9, code)
            self.assertEqual(4, len(code))

    def test_check_correctness(self):
        sys.stdout = io.StringIO()
        self.assertTrue(mastermind.check_correctness(7,4))
        self.assertEqual(sys.stdout.getvalue(), "Congratulations! You are a codebreaker!\n")

        sys.stdout = io.StringIO()
        self.assertFalse(mastermind.check_correctness(1, 3))
        self.assertEqual(sys.stdout.getvalue(), "Turns left: 11\n")

    @patch("sys.stdin", StringIO("123\n12345\n1234\n"))
    def test_get_answer_input(self):
        sys.stdout = io.StringIO()
        self.assertEqual(mastermind.get_answer_input(),"1234")
        self.assertEqual(sys.stdout.getvalue(),"""Input 4 digit code: Please enter exactly 4 digits.
Input 4 digit code: Please enter exactly 4 digits.\nInput 4 digit code: """)


if __name__ == '__main__':
    unittest.main()
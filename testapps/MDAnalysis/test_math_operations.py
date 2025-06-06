# test_math_operations.py
import unittest
from math_operations import add, subtract

class TestMathOperations(unittest.TestCase):

    def test_add(self):
        self.assertEqual(add(2, 3), 5)
        self.assertEqual(add(-1, 1), 0)

    def test_subtract(self):
        self.assertEqual(subtract(5, 3), 2)
        self.assertEqual(subtract(10, 4), 6)

if __name__ == "__main__":
    unittest.main()


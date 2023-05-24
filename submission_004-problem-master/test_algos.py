
import unittest
import super_algos

class MyTestCase(unittest.TestCase):
    def test_find_min(self):
        self.assertEqual(super_algos.find_min([58,3,6,8,9,3,11]),3)
        self.assertEqual(super_algos.find_min([58,3,6,8,9,3,11,'a']),-1)
        self.assertEqual(super_algos.find_min([]),-1)
        self.assertEqual(super_algos.find_min([3]),3)
    def test_sum_all(self):
        self.assertEqual(super_algos.sum_all([1,3,5,7,9]),25)
        self.assertEqual(super_algos.sum_all([1,3,5,7,9,'a']),-1)
        self.assertEqual(super_algos.sum_all([]),-1)
        self.assertEqual(super_algos.sum_all([5]),5)
    def test_find_possible_strings(self):
        self.assertEqual(super_algos.find_possible_strings(['a','b'],2)  ,['aa', 'ab', 'ba', 'bb'])
        self.assertEqual(super_algos.find_possible_strings(['a','b'],3)  ,['aaa', 'aab', 'aba', 'abb', 'baa', 'bab', 'bba', 'bbb'])
        self.assertEqual(super_algos.find_possible_strings(['a',1],2)  ,[])
        self.assertEqual(super_algos.find_possible_strings(['a','b'],1), ['a','b'])
        self.assertEqual(super_algos.find_possible_strings([],2) ,[])
if __name__ == '__main__':
    unittest.main()
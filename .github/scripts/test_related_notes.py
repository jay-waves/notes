import unittest

from related_notes import is_recommendable, related


class RelatedNotesTest(unittest.TestCase):
    def test_uppercase_names_are_excluded(self):
        self.assertFalse(is_recommendable("notes/README.md"))
        self.assertFalse(is_recommendable("notes/ESSENCE.typ"))
        self.assertTrue(is_recommendable("notes/virtual-mem.md"))
        self.assertTrue(is_recommendable("notes/中文.md"))

    def test_ranking_and_empty_documents(self):
        documents = {
            "a/": "神经网络 梯度下降 gradient descent",
            "b/": "梯度下降 gradient descent",
            "c/": "数据库 索引 database index",
            "empty/": "",
        }
        result = related(documents)
        self.assertEqual(result["a/"], ["b/"])
        self.assertEqual(result["b/"], ["a/"])
        self.assertEqual(result["c/"], [])
        self.assertEqual(result["empty/"], [])

    def test_top_three_and_deterministic_ties(self):
        result = related({name: "共同 关键词" for name in ("e/", "d/", "c/", "b/", "a/")})
        self.assertEqual(result["a/"], ["b/", "c/", "d/"])


if __name__ == "__main__":
    unittest.main()

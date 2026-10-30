#!/usr/bin/env python3
"""Generate related-note URLs from Markdown and Typst source files."""
import argparse
from collections import Counter, defaultdict
import json
import math
from pathlib import Path
import re

import jieba


def is_recommendable(source):
    """Exclude all-uppercase article names such as README and ESSENCE."""
    return not Path(source).stem.isupper()


def words(text):
    # Ignore URLs and code blocks, which otherwise contribute many shared tokens.
    text = re.sub(r"```[^\n]*\n.*?```|https?://[^\s)\]>]+", " ", text, flags=re.S)
    return [word for token in jieba.cut(text.lower())
            if len(word := token.strip()) > 1 and any(c.isalnum() for c in word)]


def related(documents, limit=3, keyword_limit=100):
    """Return URL-to-URL recommendations using corpus TF-IDF and cosine similarity."""
    counts = {url: Counter(words(text)) for url, text in documents.items()}
    frequency = Counter(word for counts_per_doc in counts.values() for word in counts_per_doc)
    total = len(counts)
    postings = defaultdict(list)
    for url, counts_per_doc in counts.items():
        weighted = [(word, count * (math.log((total + 1) / (frequency[word] + 1)) + 1))
                    for word, count in counts_per_doc.items()]
        weighted.sort(key=lambda item: (-item[1], item[0]))
        weighted = weighted[:keyword_limit]
        norm = math.sqrt(sum(weight * weight for _, weight in weighted))
        if norm:
            for word, weight in weighted:
                postings[word].append((url, weight / norm))

    scores = defaultdict(Counter)
    for entries in postings.values():
        for index, (left, left_weight) in enumerate(entries):
            for right, right_weight in entries[index + 1:]:
                score = left_weight * right_weight
                scores[left][right] += score
                scores[right][left] += score
    return {url: [other for other, score in sorted(scores[url].items(),
                                                     key=lambda item: (-item[1], item[0]))[:limit]
                  if score > 0]
            for url in sorted(documents)}


def main():
    from build_site import ROOT, inputs, plan

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("output", type=Path, help="output JSON file")
    args = parser.parse_args()
    output = args.output.resolve()
    documents = {}
    for source, destination, kind in plan(inputs(output)):
        if kind != "Raw" and is_recommendable(source):
            documents[destination.parent.as_posix() + "/"] = (ROOT / source).read_text(encoding="utf-8")
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(related(documents), ensure_ascii=False, indent=2) + "\n",
                      encoding="utf-8", newline="\n")
    print(f"Wrote {len(documents)} articles to {output}")


if __name__ == "__main__":
    main()

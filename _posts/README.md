# _posts Directory

This directory contains Markdown blog posts. All headers in these files follow proper English title case conventions.

## Header Rules

1. The first and last word of each header are always capitalized
2. Major words (nouns, pronouns, verbs, adjectives, adverbs, subordinating conjunctions) are capitalized
3. Minor words (articles, prepositions, coordinating conjunctions) are lowercase unless they are the first or last word

## Fixing Headers

To ensure all headers follow these rules, run:

```bash
python3 scripts/fix_markdown_headers.py
```

This script will:
- Process all Markdown files in the `_posts` directory
- Convert headers to proper title case
- Ensure proper Markdown syntax (space after `#` symbols)
- Preserve code blocks and other content

#!/usr/bin/env python3
"""
Script to update Markdown headers to proper English title case.
"""

import re
from pathlib import Path

# Minor words that should not be capitalized (unless first or last word)
MINOR_WORDS = {
    # Articles
    "a",
    "an",
    "the",
    # Coordinating conjunctions
    "and",
    "but",
    "for",
    "nor",
    "or",
    "so",
    "yet",
    # Prepositions (common ones, typically 4 letters or less)
    "as",
    "at",
    "by",
    "from",
    "in",
    "into",
    "of",
    "off",
    "on",
    "onto",
    "out",
    "over",
    "to",
    "up",
    "with",
}


def to_title_case(text):
    """
    Convert text to proper English title case.

    Args:
        text: The text to convert

    Returns:
        The text in title case
    """
    words = text.split()
    if not words:
        return text

    result = []
    for i, word in enumerate(words):
        # Always capitalize first and last word
        if i in (0, len(words) - 1):
            result.append(word.capitalize())
        # Check if word is a minor word
        elif word.lower() in MINOR_WORDS:
            result.append(word.lower())
        # Capitalize major words
        else:
            result.append(word.capitalize())

    return " ".join(result)


def process_markdown_file(filepath):
    """
    Process a Markdown file and update headers to title case.

    Args:
        filepath: Path to the Markdown file
    """
    with open(filepath, "r", encoding="utf-8") as f:
        lines = f.readlines()

    updated_lines = []
    in_code_block = False

    for line in lines:
        # Check for code block markers (``` or ~~~)
        if re.match(r"^```|^~~~", line):
            in_code_block = not in_code_block
            updated_lines.append(line)
            continue

        # Skip processing if we're inside a code block
        if in_code_block:
            updated_lines.append(line)
            continue

        # Check if line is a header (starts with one or more # with optional space)
        # This also handles malformed headers without space after #
        match = re.match(r"^(#{1,6})\s*(.*)$", line)
        if match:
            hashes, header_text = match.groups()
            # Only process if there's actual header text
            if header_text.strip():
                # Remove leading/trailing whitespace
                header_text = header_text.strip()
                # Convert to title case
                title_cased = to_title_case(header_text)
                # Reconstruct the header line with proper spacing
                updated_line = f"{hashes} {title_cased}\n"
                updated_lines.append(updated_line)
            else:
                # Empty header, keep as is
                updated_lines.append(line)
        else:
            updated_lines.append(line)

    # Write the updated content back to the file
    with open(filepath, "w", encoding="utf-8") as f:
        f.writelines(updated_lines)

    print(f"Updated: {filepath}")


def main():
    """Main function to process all Markdown files in _posts directory."""
    posts_dir = Path(
        "/home/runner/work/advent-of-code-solutions/advent-of-code-solutions/_posts"
    )

    if not posts_dir.exists():
        print(f"Directory {posts_dir} does not exist")
        return

    # Find all Markdown files
    md_files = list(posts_dir.glob("*.md"))

    if not md_files:
        print(f"No Markdown files found in {posts_dir}")
        return

    print(f"Found {len(md_files)} Markdown file(s) to process")

    for md_file in md_files:
        process_markdown_file(md_file)

    print("Done!")


if __name__ == "__main__":
    main()

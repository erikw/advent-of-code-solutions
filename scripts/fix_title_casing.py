#!/usr/bin/env python3
"""
Fix title casing in markdown headers.

This script fixes title casing in markdown files by applying proper
English title case rules to all headers (lines starting with #).
"""

import re
import sys
from pathlib import Path

# Words that should not be capitalized in title case (unless first/last word)
MINOR_WORDS = {
    # Articles
    'a', 'an', 'the',
    # Conjunctions
    'and', 'but', 'or', 'nor', 'for', 'yet', 'so',
    # Prepositions
    'of', 'in', 'to', 'from', 'with', 'on', 'at', 'by',
    'into', 'onto', 'upon', 'within', 'without', 'through',
    'throughout', 'over', 'under', 'above', 'below', 'between', 'among',
    'during', 'before', 'after', 'until', 'since', 'about', 'against',
    'around', 'behind', 'beneath', 'beside', 'besides', 'beyond', 'down',
    'except', 'inside', 'like', 'near', 'off', 'out', 'outside', 'past',
    'per', 'toward', 'towards', 'underneath', 'unlike', 'up', 'via',
    'across', 'along', 'amid', 'as', 'despite', 'following', 'minus',
    'next', 'opposite', 'plus', 'regarding', 'round', 'save', 'than',
    'versus', 'vs', 'vs.', 'worth'
}


def to_title_case(text):
    """Convert text to proper title case.
    
    Args:
        text: The text to convert
        
    Returns:
        The text in proper title case
    """
    # Split into words, preserving whitespace and punctuation
    words = text.split()
    if not words:
        return text
    
    result = []
    for i, word in enumerate(words):
        # Check if word has special characters or numbers
        # Preserve original casing for acronyms or special terms
        if ':' in word:
            # For words with colons (like "day 1:"), handle specially
            parts = word.split(':')
            fixed_parts = []
            for j, part in enumerate(parts):
                if part:
                    if i == 0 or i == len(words) - 1 or part.lower() not in MINOR_WORDS:
                        fixed_parts.append(part.capitalize())
                    else:
                        fixed_parts.append(part.lower())
                else:
                    fixed_parts.append(part)
            result.append(':'.join(fixed_parts))
        else:
            # Regular word
            word_lower = word.lower()
            
            # First and last words are always capitalized
            if i == 0 or i == len(words) - 1:
                result.append(word.capitalize())
            # Check if it's a minor word
            elif word_lower in MINOR_WORDS:
                result.append(word_lower)
            else:
                result.append(word.capitalize())
    
    return ' '.join(result)


def fix_markdown_headers(content):
    """Fix title casing in markdown headers.
    
    Args:
        content: The markdown file content
        
    Returns:
        The content with fixed title casing in headers
    """
    lines = content.split('\n')
    fixed_lines = []
    
    for line in lines:
        # Check if line is a markdown header
        match = re.match(r'^(#{1,6})\s+(.+?)(\s*)$', line)
        if match:
            hashes, title, trailing_space = match.groups()
            fixed_title = to_title_case(title)
            fixed_lines.append(f'{hashes} {fixed_title}{trailing_space}')
        else:
            fixed_lines.append(line)
    
    return '\n'.join(fixed_lines)


def process_file(filepath):
    """Process a single markdown file.
    
    Args:
        filepath: Path to the markdown file
    """
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        fixed_content = fix_markdown_headers(content)
        
        if content != fixed_content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(fixed_content)
            print(f'Fixed: {filepath}')
            return True
        else:
            print(f'No changes: {filepath}')
            return False
    except Exception as e:
        print(f'Error processing {filepath}: {e}', file=sys.stderr)
        return False


def main():
    """Main function to process all markdown files in _posts directory."""
    posts_dir = Path('_posts')
    
    if not posts_dir.exists():
        print(f'Directory {posts_dir} does not exist.')
        sys.exit(1)
    
    # Find all markdown files
    md_files = list(posts_dir.glob('*.md'))
    
    if not md_files:
        print(f'No markdown files found in {posts_dir}')
        sys.exit(0)
    
    print(f'Found {len(md_files)} markdown file(s) to process\n')
    
    fixed_count = 0
    for md_file in sorted(md_files):
        if process_file(md_file):
            fixed_count += 1
    
    print(f'\nProcessed {len(md_files)} file(s), fixed {fixed_count} file(s)')


if __name__ == '__main__':
    main()

#!/usr/bin/env python3
import fileinput
from pprint import pprint

def main():
    for line in fileinput.input():
        line = line.rstrip("\n")

if __name__ == '__main__':
	main()

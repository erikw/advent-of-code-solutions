#!/usr/bin/env node
"use strict";

import { readFileSync } from "node:fs";

import "../../utils/commons.js";
import { dir_sizes_from_terminal_session } from "./lib.js";

const MAX_SIZE = 100000;

let termsession = readFileSync(process.argv[2])
  .toString()
  .trimEnd()
  .split("\n");

const dir_sizes = dir_sizes_from_terminal_session(termsession);

const filtered = Object.filter(dir_sizes, ([, size]) => size <= MAX_SIZE);
const sum = Object.values(filtered).reduce((sum, size) => sum + size);
console.log(sum);

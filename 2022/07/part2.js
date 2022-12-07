#!/usr/bin/env node
"use strict";

import { readFileSync } from "node:fs";
import { dir_sizes_from_terminal_session } from "./lib.js";

const SIZE_FS = 70000000;
const SIZE_UPDATE = 30000000;

let termsession = readFileSync(process.argv[2])
  .toString()
  .trimEnd()
  .split("\n");

const dir_sizes = dir_sizes_from_terminal_session(termsession);
const size_unused = SIZE_FS - dir_sizes["/"];
const size_needed = SIZE_UPDATE - size_unused;

const size_to_delete = Object.values(dir_sizes)
  .sort((a, b) => a - b)
  .find((size) => size >= size_needed);
console.log(size_to_delete);

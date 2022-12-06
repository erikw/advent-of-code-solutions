#!/usr/bin/env node
"use strict";

import { readFileSync } from "node:fs";

const WIN_LEN = 14;

let chars = readFileSync(process.argv[2]).toString().trimEnd();

const win = [];
let i = 0;
for (const char of chars) {
  win.push(char);
  i++;
  if (win.length > WIN_LEN) win.shift();
  if (win.length == WIN_LEN && new Set(win).size == WIN_LEN) break;
}
console.log(i);

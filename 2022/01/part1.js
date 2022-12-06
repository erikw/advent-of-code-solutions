#!/usr/bin/env node
const fs = require("node:fs");

let elf_calories = fs
  .readFileSync(process.argv[2])
  .toString()
  .trim()
  .split("\n\n")
  .map((calories) => {
    return calories
      .split("\n")
      .map((cal) => Number.parseInt(cal, 10))
      .reduce((sum, cal) => sum + cal);
  });

let max_cal = Math.max(...elf_calories);
console.log(max_cal);

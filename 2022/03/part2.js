#!/usr/bin/env node
"use strict";

import { readFileSync } from "node:fs";
import "../../utils/commons.js";

function getPriority(char) {
  const sub =
    char == char.toUpperCase() ? "A".charCodeAt(0) - 27 : "a".charCodeAt(0) - 1;
  return char.charCodeAt(0) - sub;
}

let knapsacks = readFileSync(process.argv[2])
  .toString()
  .trim()
  .split("\n")
  .map((l) => l.split(""));

let priority = 0;
knapsacks.eachSlice(3, (group) => {
  const comp1 = new Set(group[0]);
  const comp2 = new Set(group[1]);
  const comp3 = new Set(group[2]);
  const intersection = comp1.intersection(comp2).intersection(comp3);

  for (const item of intersection) {
    priority += getPriority(item);
  }
});

console.log(priority);

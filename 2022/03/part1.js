#!/usr/bin/env node
"use strict";

import { readFileSync } from "node:fs";

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
knapsacks.forEach((knapsack) => {
  const comp1 = new Set(knapsack.slice(0, knapsack.length / 2));
  const comp2 = new Set(knapsack.slice(knapsack.length / 2));
  const intersection = new Set([...comp1].filter((e) => comp2.has(e)));

  for (const item of intersection) {
    priority += getPriority(item);
  }
});

console.log(priority);

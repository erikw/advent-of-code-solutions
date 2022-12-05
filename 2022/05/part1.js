#!/usr/bin/env node
"use strict";

import { readFileSync } from "node:fs";
import "../../utils/commons.js";

let [input_stacks, input_proceedure] = readFileSync(process.argv[2])
  .toString()
  .trimEnd()
  .split("\n\n")
  .map((part) => part.split("\n"));

const stacks = input_stacks
  .map((row) => [...row])
  .transpose()
  .map((row) => row.join("").replaceAll(/\[|\]/g, "").trim())
  .filter((row) => row !== "")
  .map((row) => [...row.slice(0, -1)].reverse());

const proceedure = input_proceedure.map((line) =>
  Array.from(line.matchAll(/\d+/g), (d) => Number.parseInt(d, 10))
);

proceedure.forEach(([number, from, to]) => {
  const moved = stacks[from - 1].splice(-number, number);
  stacks[to - 1].push(...moved.reverse());
});

const top_crates = stacks.map((stack) => stack.at(-1)).join("");
console.log(top_crates);

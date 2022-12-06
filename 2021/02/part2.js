#!/usr/bin/env node
const fs = require("node:fs");

var instructions = fs
  .readFileSync(process.argv[2])
  .toString()
  .trim()
  .split("\n");

let pos = 0;
let depth = 0;
let aim = 0;

instructions.forEach((instruction) => {
  let [cmd, val] = instruction.split(" ");
  val = Number.parseInt(val, 10);

  switch (cmd) {
    case "forward":
      pos += val;
      depth += aim * val;
      break;
    case "down":
      aim += val;
      break;
    case "up":
      aim -= val;
      break;
  }
});

console.log(pos * depth);

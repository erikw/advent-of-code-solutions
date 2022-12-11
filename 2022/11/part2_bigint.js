#!/usr/bin/env node
"use strict";

// Does not work, too slow!

import { readFileSync } from "node:fs";
import { load as yamlLoad } from "js-yaml";

import "../../utils/commons.js";

const ROUNDS = 10000;

let inputYaml = readFileSync(process.argv[2])
  .toString()
  .toLowerCase()
  .replaceAll(/ {2}if /g, "")
  .replaceAll(/starting /g, "")
  .replaceAll(/throw to /g, "")
  .replaceAll(/monkey /g, "")
  .replaceAll(/divisible by /g, "")
  .replaceAll(/test:/g, "test_div:")
  .replaceAll(/(new|old)/g, "item");
let monkeys = yamlLoad(inputYaml);

for (const monkey of monkeys.values()) {
  monkey.inspections = 0;
  if (typeof monkey.items == "string") {
    monkey.items = monkey.items
      .split(", ")
      .map((n) => BigInt(Number.parseInt(n, 10)));
  } else {
    monkey.items = [BigInt(monkey.items)];
  }
  monkey.test_div = BigInt(monkey.test_div);
  monkey.operation = monkey.operation.replaceAll(/\d+/g, "BigInt($&)");
}

for (let round = 0; round < ROUNDS; ++round) {
  monkeys.entries().forEach(([monkeyNum, monkey]) => {
    monkey.inspections += monkey.items.length;
    monkey.items.forEach((item) => {
      eval(monkey.operation);

      const destMonkey =
        item % monkey.test_div == 0 ? monkey.true : monkey.false;
      monkeys[destMonkey].items.push(item);
    });
    monkey.items = [];
  });
  if (
    [
      1, 20, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 1000,
    ].includes(round + 1)
  ) {
    console.log(`\nAfter round ${round + 1}:`);
    monkeys.entries().forEach(([monkeyNum, monkey]) => {
      console.log(
        `Monkey ${monkeyNum} inspected ${
          monkey.inspections
        } times currently having items ${monkey.items.join(", ")}`
      );
    });
  }
}

const monkey_business = monkeys
  .values()
  .sort((a, b) => a.inspections - b.inspections)
  .slice(-2)
  .map((m) => m.inspections)
  .mul();
console.log(
  monkeys
    .values()
    .sort((a, b) => a.inspections - b.inspections)
    .map((m) => m.inspections)
);
console.log(monkey_business);

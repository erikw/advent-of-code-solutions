#!/usr/bin/env node
"use strict";

import { readFileSync } from "node:fs";
import { load as yamlLoad } from "js-yaml";

import "../../utils/commons.js";

const ROUNDS = 20;
const WORRY_DIVIDER = 3;

const yaml = readFileSync(process.argv[2])
  .toString()
  .toLowerCase()
  .replaceAll(/ {2}if /g, "")
  .replaceAll(/starting /g, "")
  .replaceAll(/throw to /g, "")
  .replaceAll(/monkey /g, "")
  .replaceAll(/divisible by /g, "")
  .replaceAll(/test:/g, "test_div:")
  .replaceAll(/(new|old)/g, "item");
const monkeys = yamlLoad(yaml);

for (const monkey of monkeys.values()) {
  monkey.inspections = 0;
  if (typeof monkey.items != "string") monkey.items = monkey.items.toString();
  monkey.items = monkey.items.split(", ").map((n) => Number.parseInt(n, 10));
}

for (let round = 0; round < ROUNDS; ++round) {
  monkeys.values().forEach((monkey) => {
    monkey.inspections += monkey.items.length;
    monkey.items.forEach((item) => {
      eval(monkey.operation);
      item = Math.floor(item / WORRY_DIVIDER);
      const destMonkey =
        item % monkey.test_div == 0 ? monkey.true : monkey.false;
      monkeys[destMonkey].items.push(item);
    });
    monkey.items = [];
  });
}

const monkey_business = monkeys
  .values()
  .sort((a, b) => a.inspections - b.inspections)
  .slice(-2)
  .map((m) => m.inspections)
  .mul();
console.log(monkey_business);

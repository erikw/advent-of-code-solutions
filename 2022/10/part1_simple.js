#!/usr/bin/env node
"use strict";

// Same as part1.js but without the optimizations (simulation logic) for future ops with long cycles.

import { readFileSync } from "node:fs";

import "../../utils/commons.js";

const INSPECT_CYCLE = 40;

class Computer {
  #inspect_cycle;
  #reg = { X: 1 };
  #signal_strengths = [];
  #cycle = 0;

  constructor(inspect_cycle = null) {
    this.#inspect_cycle = inspect_cycle;
  }

  get registers() {
    return this.#reg;
  }

  get signal_strengths() {
    return this.#signal_strengths;
  }

  execute(instructions) {
    this.#reg = { X: 1 };
    this.#signal_strengths = [];
    this.#cycle = 0;

    for (const [op, ...args] of instructions) {
      switch (op) {
        case "addx":
          this.#runCycles(2);
          this.#reg["X"] += Number.parseInt(args[0], 10);
          break;
        case "noop":
          this.#runCycles(1);
          break;

        default:
          throw "cmd parsing error";
      }
    }
  }

  #runCycles(steps) {
    for (let i = 0; i < steps; i++) {
      this.#cycle++;
      this.#inspect();
    }
  }

  #inspect() {
    if (this.#inspect_cycle == null) return;

    if (this.#cycle % this.#inspect_cycle == 20) {
      this.#signal_strengths.push(this.#reg["X"] * this.#cycle);
    }
  }
}

let instructions = readFileSync(process.argv[2])
  .toString()
  .trimEnd()
  .split("\n")
  .map((l) => l.split(" "));

const computer = new Computer(INSPECT_CYCLE);
computer.execute(instructions);
const sum = computer.signal_strengths.sum();
console.log(sum);

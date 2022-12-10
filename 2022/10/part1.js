#!/usr/bin/env node
"use strict";

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
      let oldX = this.#reg["X"];
      let cycleJump = null;
      switch (op) {
        case "addx":
          this.#reg["X"] += Number.parseInt(args[0], 10);
          cycleJump = 2;
          break;
        case "noop":
          cycleJump = 1;
          break;

        default:
          throw "cmd parsing error";
      }
      this.#inspect(oldX, cycleJump);
      this.#cycle += cycleJump;
    }
  }

  #inspect(oldX, cycleJump) {
    if (this.#inspect_cycle == null) return;

    let mod = this.#cycle % this.#inspect_cycle;
    if (mod == 20) return;
    let missing = 20 - mod;
    if (missing > 0 && cycleJump >= missing) {
      const inspectCycle = this.#cycle + missing;
      this.#signal_strengths.push(oldX * inspectCycle);
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

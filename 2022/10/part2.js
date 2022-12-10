#!/usr/bin/env node
"use strict";

import { readFileSync } from "node:fs";

import "../../utils/commons.js";

const CRT_ROWS = 6;
const CRT_COLS = 40;

const SYM_OFF = ".";
const SYM_ON = "#";

class Computer {
  #reg = { X: 1 };
  #cycle = 0;
  #crt;

  constructor(crt) {
    this.#crt = crt;
  }

  get registers() {
    return this.#reg;
  }

  execute(instructions) {
    this.#reg = { X: 1 };
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
      this.#crt.draw(this.#reg["X"] - 1, this.#reg["X"] + 1);
    }
    this.#cycle += steps;
  }
}

class CRT {
  #posRow = 0;
  #posCol = 0;
  #rows;
  #cols;
  #display;

  constructor(rows, cols) {
    this.#rows = rows;
    this.#cols = cols;
    this.#display = Array(this.#rows)
      .fill()
      .map(() => Array(this.#cols).fill());
  }

  view() {
    this.#display.forEach((row) => {
      console.log(row.join(""));
    });
  }

  draw(sprite_start, sprite_end) {
    if (this.#posCol.inRange(sprite_start, sprite_end)) {
      this.#display[this.#posRow][this.#posCol] = SYM_ON;
    } else {
      this.#display[this.#posRow][this.#posCol] = SYM_OFF;
    }
    this.#advancePos();
  }

  #advancePos() {
    if (this.#posCol + 1 == this.#display[0].length) {
      this.#posRow = (this.#posRow + 1) % this.#display.length;
    }
    this.#posCol = (this.#posCol + 1) % this.#display[0].length;
  }
}

let instructions = readFileSync(process.argv[2])
  .toString()
  .trimEnd()
  .split("\n")
  .map((l) => l.split(" "));

const crt = new CRT(CRT_ROWS, CRT_COLS);
const computer = new Computer(crt);
computer.execute(instructions);
crt.view();

#!/usr/bin/env node
"use strict";

import { create, all } from "mathjs";
const math = create(all, {});

import { gridFromInput, dijkstra } from "./lib.js";

const START_ELEVATION = 0;

const [grid, , pos_end] = gridFromInput();

let startPositions = [];
for (let row = 0; row < grid.length; ++row) {
  for (let col = 0; col < grid[0].length; ++col) {
    if (grid[row][col] == START_ELEVATION) {
      startPositions.push(math.complex(row, col));
    }
  }
}

const minDist = startPositions
  .map((pos) => dijkstra(grid, pos, pos_end)[0].get(pos_end.key()))
  .min();

console.log(minDist);

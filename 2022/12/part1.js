#!/usr/bin/env node
"use strict";

import { gridFromInput, dijkstra } from "./lib.js";

const [grid, pos_start, pos_end] = gridFromInput();
const [dist] = dijkstra(grid, pos_start, pos_end);
const shortestDist = dist.get(pos_end.key());
console.log(shortestDist);

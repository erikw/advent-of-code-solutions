#!/usr/bin/env node
"use strict";

import "../../utils/commons.js";
import { readInput, cmp } from "./lib.js";

const inOrder = (left, right) => {
  return cmp(left, right) < 0;
};

const pairs = readInput();

let idxSum = pairs
  .map((pair, i) => [pair, i])
  .filter(([pair]) => inOrder(pair[0], pair[1]))
  .map(([, i]) => i + 1)
  .sum();
console.log(idxSum);

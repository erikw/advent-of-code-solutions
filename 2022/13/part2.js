#!/usr/bin/env node
"use strict";

import "../../utils/commons.js";
import { readInput, cmp } from "./lib.js";

const DIVIDER_PKGS = [[[2]], [[6]]];

const pairs = readInput().flat(1);
pairs.push(...DIVIDER_PKGS);

let sorted = pairs.sort((a, b) => cmp(a, b));
const decoderKey = DIVIDER_PKGS.map((pkg) => sorted.indexOf(pkg) + 1).mul();
console.log(decoderKey);

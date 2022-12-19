#!/usr/bin/env node
"use strict";

import { readFileSync } from "node:fs";

const input = readFileSync(process.argv[2]).toString().trimEnd().split("\n");

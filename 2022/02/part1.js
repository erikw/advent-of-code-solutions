#!/usr/bin/env node
"use strict";

import { readFileSync } from "node:fs";
import {
  Symbols,
  OpponentToSymbol,
  SymbolToScore,
  Outcomes,
  OutcomeToScore,
} from "./lib.js";

export const ReplyToSymbol = {
  X: Symbols.ROCK,
  Y: Symbols.PAPER,
  Z: Symbols.SCISSOR,
};

const RoundResolution = {
  [Symbols.ROCK]: {
    [Symbols.ROCK]: Outcomes.DRAW,
    [Symbols.PAPER]: Outcomes.WON,
    [Symbols.SCISSOR]: Outcomes.LOST,
  },
  [Symbols.PAPER]: {
    [Symbols.ROCK]: Outcomes.LOST,
    [Symbols.PAPER]: Outcomes.DRAW,
    [Symbols.SCISSOR]: Outcomes.WON,
  },
  [Symbols.SCISSOR]: {
    [Symbols.ROCK]: Outcomes.WON,
    [Symbols.PAPER]: Outcomes.LOST,
    [Symbols.SCISSOR]: Outcomes.DRAW,
  },
};

let rounds = readFileSync(process.argv[2])
  .toString()
  .trim()
  .split("\n")
  .map((l) => l.split(" "));

let score = 0;
rounds.forEach(([opponent, reply]) => {
  let sym_opp = OpponentToSymbol[opponent];
  let sym_rpl = ReplyToSymbol[reply];
  let outcome = RoundResolution[sym_opp][sym_rpl];

  score += SymbolToScore[sym_rpl] + OutcomeToScore[outcome];
});

console.log(score);

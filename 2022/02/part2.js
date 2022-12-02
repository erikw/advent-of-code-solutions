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

const ReplyToOutcome = {
  X: Outcomes.LOST,
  Y: Outcomes.DRAW,
  Z: Outcomes.WON,
};

const RoundResolution = {
  [Symbols.ROCK]: {
    [Outcomes.LOST]: Symbols.SCISSOR,
    [Outcomes.DRAW]: Symbols.ROCK,
    [Outcomes.WON]: Symbols.PAPER,
  },
  [Symbols.PAPER]: {
    [Outcomes.LOST]: Symbols.ROCK,
    [Outcomes.DRAW]: Symbols.PAPER,
    [Outcomes.WON]: Symbols.SCISSOR,
  },
  [Symbols.SCISSOR]: {
    [Outcomes.LOST]: Symbols.PAPER,
    [Outcomes.DRAW]: Symbols.SCISSOR,
    [Outcomes.WON]: Symbols.ROCK,
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
  let outcome = ReplyToOutcome[reply];
  let sym_rpl = RoundResolution[sym_opp][outcome];

  score += SymbolToScore[sym_rpl] + OutcomeToScore[outcome];
});

console.log(score);

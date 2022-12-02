export const Symbols = {
  ROCK: "rock",
  PAPER: "paper",
  SCISSOR: "scissor",
};
Object.freeze(Symbols);

export const OpponentToSymbol = {
  A: Symbols.ROCK,
  B: Symbols.PAPER,
  C: Symbols.SCISSOR,
};

export const SymbolToScore = {
  [Symbols.ROCK]: 1,
  [Symbols.PAPER]: 2,
  [Symbols.SCISSOR]: 3,
};

export const Outcomes = {
  LOST: "lost",
  DRAW: "draw",
  WON: "won",
};

export const OutcomeToScore = {
  [Outcomes.LOST]: 0,
  [Outcomes.DRAW]: 3,
  [Outcomes.WON]: 6,
};

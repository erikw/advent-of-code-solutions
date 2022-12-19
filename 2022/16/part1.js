#!/usr/bin/env node
"use strict";

import { readFileSync } from "node:fs";

import "../../utils/commons.js";

const ERUPTION_MIN = 30;
const VALVE_START = "AA";

const R_INPUT = /([A-Z]{2}).+?(\d+).*?((?:[A-Z]{2}(?:, )?)+)/;
const valves = new Map(); // valve -> [flow, [leadsTo]]

const currentFlow = (valves, on) => {
  return Array.from(on.values())
    .map((valve) => valves.get(valve)[0])
    .sum();
};

// TODO how to deal with infinite loops? Because loops are allowed.
const maxRelease = (
  valves,
  curValve = VALVE_START,
  on = new Set(),
  releasedFlow = 0,
  timeRemaining = ERUPTION_MIN
) => {
  console.log(
    `maxRelease(time = ${timeRemaining}, curValve = ${curValve}, on = ${[
      ...on.values(),
    ]}`
  );
  if (timeRemaining < 0) {
    return releasedFlow;
  } else if (
    on.size == Array.from(valves.values()).count(([flow]) => flow > 0)
  ) {
    return releasedFlow + currentFlow(valves, on) * timeRemaining;
  }
  const updatedFlow = releasedFlow + currentFlow(valves, on);

  let maxFlow = 0;
  for (const neighbourValve of valves.get(curValve)[1]) {
    let flowOn = 0;
    if (!on.has(neighbourValve) && timeRemaining >= 2) {
      const onClone = new Set(on);
      onClone.add(neighbourValve);
      flowOn = maxRelease(
        valves,
        neighbourValve,
        onClone,
        updatedFlow,
        timeRemaining - 2
      );
    }
    const flowOff = maxRelease(
      valves,
      neighbourValve,
      on,
      updatedFlow,
      timeRemaining - 1
    );

    maxFlow = [maxFlow, flowOn, flowOff].max();
  }
  return maxFlow;
};

readFileSync(process.argv[2])
  .toString()
  .trimEnd()
  .split("\n")
  .map((line) => {
    return [...line.match(R_INPUT)].slice(1);
  })
  .forEach(([valve, flow, leadsTo]) => {
    valves.set(valve, [flow, leadsTo.split(", ")]);
  });

// We're looking for a Hamiltonian Path, maximizing the preassure flow (rep. as values of node (flow * path order)?)
// NOPE a Hamiltonian Path visites each node only once, not needed here.
//

console.log(valves);

const release = maxRelease(valves);
console.log(release);

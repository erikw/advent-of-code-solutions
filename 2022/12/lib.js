import { readFileSync } from "node:fs";
import { create, all, Complex } from "mathjs";
const math = create(all, {});
import PriorityQueue from "algorithms/data_structures/priority_queue.js";

import { DefaultMap } from "../../utils/commons.js";

const SYM = {
  START: "S",
  END: "E",
  UNVISITED: ".",
};

const DIR_DELTA = {
  NORTH: math.complex(-1, 0),
  EAST: math.complex(0, 1),
  SOUTH: math.complex(1, 0),
  WEST: math.complex(0, -1),
};

Complex.prototype.key = function () {
  return this.toString();
};

export const gridFromInput = () => {
  let pos_start;
  let pos_end;
  let grid = readFileSync(process.argv[2])
    .toString()
    .trimEnd()
    .split("\n")
    .map((line, row) => {
      return line.split("").map((char, col) => {
        if (char == SYM.START) {
          pos_start = math.complex(row, col);
          char = "a";
        } else if (char == SYM.END) {
          pos_end = math.complex(row, col);
          char = "z";
        }
        return char.charCodeAt(0) - "a".charCodeAt(0);
      });
    });
  return [grid, pos_start, pos_end];
};

// NOTE this assumes positions are math.complex and that this prototype is extended with a .key() to make the implementation below easier.
export const dijkstra = (grid, source, target) => {
  const dist = new DefaultMap(() => Infinity, [[source.key(), 0]]);
  const prev = new Map();

  var pq = new PriorityQueue({ [source.key()]: dist.get(source.key()) });

  while (!pq.isEmpty()) {
    const pos = math.complex(pq.extract());
    if (pos.equals(target)) return [dist, prev];

    DIR_DELTA.values().forEach((dirDelta) => {
      const posn = pos.add(dirDelta);
      if (
        !posn.re.inRange(0, grid.length - 1) ||
        !posn.im.inRange(0, grid[0].length - 1) ||
        grid[pos.re][pos.im] + 1 < grid[posn.re][posn.im]
      ) {
        return;
      }

      const alt = dist.get(pos.key()) + 1;
      if (dist.get(posn.key()) < alt) return;

      dist.set(posn.key(), alt);
      prev.set(posn.key(), pos.key());
      pq.insert(posn.key(), alt);
    });
  }

  return [dist, prev];
};

// Back-tracking of Dijkstra's algorithm's "prev" output to find the shortests path from source to target.
export const backtrack_path = (prev, source, target) => {
  source = source.key();
  target = target.key();
  const path = [];
  let pos = target;
  if (prev.get(pos) || pos == source) {
    while (pos) {
      path.unshift(pos);
      pos = prev.get(pos);
    }
  }
  return path;
};

export const printGrid = (grid) => {
  grid.forEach((row) => {
    console.log(
      row.map((c) => String.fromCharCode(c + "a".charCodeAt(0))).join("")
    );
  });
};

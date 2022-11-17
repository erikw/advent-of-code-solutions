#!/usr/bin/env node

const fs = require('node:fs');

const transpose = matrix => matrix[0].map((x, i) => matrix.map(y => y[i]));
const mostCommonBit = (numbers, col) => (transpose(numbers)[col].reduce((sum, nbr) => sum + nbr, 0) >=  numbers.length / 2) ? 1 : 0;

var numbers = fs.readFileSync(process.argv[2]).toString().trim().split("\n").map(l => Array.from(l).map(v => Number.parseInt(v, 10)));

let n = numbers;
let i = 0;
while (n.length > 1) {
	const mostCommon = mostCommonBit(n, i);
	n = n.filter(nbr => nbr[i] === mostCommon);
	i += 1;
}
let oxygen = Number.parseInt(n[0].join(''), 2);
console.log({oxygen})

n = numbers;
i = 0;
while (n.length > 1) {
	const mostCommon = mostCommonBit(n, i);
	n = n.filter(nbr => nbr[i] === ((mostCommon + 1) % 2));
	i += 1;
}
let scrub = Number.parseInt(n[0].join(''), 2);
console.log({scrub})

console.log(oxygen * scrub);

#!/usr/bin/env node

const fs = require('node:fs');

const transpose = matrix => matrix[0].map((x, i) => matrix.map(y => y[i]));

var numbers = fs.readFileSync(process.argv[2]).toString().trim().split("\n").map(l => Array.from(l).map(v => Number.parseInt(v, 10)));
numbers = transpose(numbers);

let gamma_s = "";
let epsilon_s = "";
numbers.forEach(row => {
	let sum = row.reduce((sum ,val) => sum + val, 0);
	gamma_s += (sum >= row.length / 2) ? '1' : '0';
    epsilon_s += gamma_s.at(-1) == '0' ? '1' : '0';
});

let gamma = Number.parseInt(gamma_s, 2);
let epsilon = Number.parseInt(epsilon_s, 2);

let power = gamma * epsilon;
console.log(power);

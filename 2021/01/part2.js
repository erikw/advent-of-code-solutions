#!/usr/bin/env node
const fs = require('node:fs');

const WIN_SIZE = 3;

var measurements = fs.readFileSync(process.argv[2]).toString().trim().split("\n").map(l => Number.parseInt(l, 10));

let win = [];
let inc = 0;
let prev = null;
measurements.forEach(function(measure) {
	win.push(measure);
	win.length > WIN_SIZE && win.shift();
	if (win.length === WIN_SIZE) {
		let win_sum = win.reduce((acc, val) => acc + val);
		if (prev !== null && win_sum > prev) {
			inc++;
		}
		prev = win_sum;
	}
});

console.log(inc);

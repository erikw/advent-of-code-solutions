#!/usr/bin/env node
const fs = require('node:fs');

var measurements = fs.readFileSync(process.argv[2]).toString().trim().split("\n").map(l => Number.parseInt(l, 10));

let inc = 0;
let prev = null;
measurements.forEach(function(measure) {
	if (prev !== null && measure > prev) {
		inc++;
	}
	prev = measure;
});


console.log(inc);

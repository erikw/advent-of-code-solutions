#!/usr/bin/env node
const fs = require('node:fs');

var instructions = fs.readFileSync(process.argv[2]).toString().trim().split("\n")

let pos = 0;
let depth = 0;

instructions.forEach(instruction => {
	let [cmd, val] = instruction.split(' ');
	val = Number.parseInt(val, 10);

	switch(cmd) {
		case "forward":
			pos += val;
		break;
		case "down":
			depth += val;
		break;
		case "up":
			depth -= val;
		break;
	}
});

console.log(pos * depth);

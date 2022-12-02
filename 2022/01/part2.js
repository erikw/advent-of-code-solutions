#!/usr/bin/env node
const fs = require('node:fs');

let elf_calories = fs.readFileSync(process.argv[2]).toString().trim().split("\n\n").map(calories => {
	return calories.split('\n').map(cal => Number.parseInt(cal, 10)).reduce((sum, cal) => sum + cal);
});
elf_calories.sort((a, b ) => a - b);
let max_cal = elf_calories.slice(-3).reduce((sum ,cal) => sum + cal);
console.log(max_cal);

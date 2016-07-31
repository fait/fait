#!/usr/bin/env node

var resolve = require('resolve');

var resolved = resolve.sync(process.argv[2], {
	basedir: process.argv[3] || process.cwd(),
	extensions: ['.mk'],
});

console.log(resolved);

#!/usr/bin/env node

var resolve = require('resolve');
var chalk = require('chalk');
chalk.enabled = true;

try {
	var resolved = resolve.sync(process.argv[2], {
		basedir: process.argv[3] || process.cwd(),
		extensions: ['.mk'],
	});

	console.log(resolved);
} catch(e) {
	console.log(chalk.red('✘') + ' ' + chalk.grey(e.message));
	process.exit(1);
}

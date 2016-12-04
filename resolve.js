#!/usr/bin/env node

var resolve = require('resolve');
var path = require('path');
var chalk = require('chalk');
chalk.enabled = true;

function isRelative(path) {
	return /^..?\./.test(path);
}

function isBareModule(path) {
	return !isRelative(path) && !/\//.test(path);
}

var module = process.argv[2];

try {
	var resolved = resolve.sync(module, {
		basedir: process.argv[3] || process.cwd(),
		extensions: ['.mk'],
		packageFilter: function(pkg) {
			pkg.main = pkg.faitMain || pkg.main;
			return pkg;
		}
	});

	console.log(resolved);
} catch(e) {
	if(isBareModule(module)) {
		console.log(path.join('node_modules', module, 'index.mk'));
	} else {
		console.log(chalk.red('✘') + ' ' + chalk.grey.bold(e.message));
		process.exit(1);
	}
}

const fs = require('fs');

const input = fs.readFileSync(process.argv[2], 'utf8');

console.log(
	input
		.replace(new RegExp(`
#   ╭─╮   ⡀
#   ┼╴╭─╮ ┐ ┼╴
#   │ ╭─┤ │ │
#   ┴ ╰─╰ ┴ ╰╯
#  ╺══════════╸
#   .+
`.trim()), '')
		.replace(/(\n#.+\n)(?!#)/g, '$1\n```makefile\n')
		.replace(/\n(?!#)(.+)(\n#|$)/g, '\n$1\n```\n')
		.replace(/^# {0,3}/gm, '')
		.replace(/╺══════════╸/g, '---')
		.trim()
);
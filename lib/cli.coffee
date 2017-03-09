program = require 'commander'
chalk = require 'chalk'
extend = require 'smart-extend'
defaults = extend.clone require './defaults'
defaults.src = defaults.src.replace process.cwd(),'.'
defaults.dest = defaults.dest.replace process.cwd(),'.'
defaults.configFile = defaults.configFile.replace process.cwd(),'.'

program
	.version require('../package.json').version
	.option '-s --src [path]', "Path of dir containing SVG icon files [default: #{chalk.dim defaults.src}]"
	.option '-d --dest [path]', "Path of dir that the generated font files should be written to [default: #{chalk.dim defaults.dest}]"
	.option '-f --fontName [name]', "Name to assign to the generated icon font [default: #{chalk.dim defaults.fontName}]"
	.option '-c --configFile [path]', "Path of the file containing the icon config [default: #{chalk.dim defaults.configFile}]"
	.option '-t --type [path]', "Font file types to generate (specifiy multiple times for multiple types) [default: #{chalk.dim defaults.types}]", ((type, types)->types.push(type); types), []
	.option '-S --silent', "Normalize icons by scaling them to the height of the highest icon [default: #{chalk.dim 'false'}]"
	.option '--no-css', "Avoid generating a css file [default: #{chalk.dim defaults.css}]"
	.option '--no-html', "Avoid generating an html preview [default: #{chalk.dim defaults.html}]"
	.option '--no-image', "Avoid generating an image preview [default: #{chalk.dim defaults.image}]"
	.option '--no-saveConfig', "Avoid saving the generated config file to disk [default: #{chalk.dim defaults.saveConfig}]"
	.option '--no-fixedHeight', "Normalize icons by scaling them to the height of the highest icon [default: #{chalk.dim defaults.normalize}]"
	.parse(process.argv)

program.silent ?= false
program.types = program.type if program.type.length
program.normalize = false if program.fixedHeight is false
require('./icon.font')(program)

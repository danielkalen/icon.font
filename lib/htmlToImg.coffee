Promise = require 'bluebird'
path = require 'path'
chalk = require 'chalk'
exec = require 'execa'
fs = require 'fs-jetpack'
electroshot = path.resolve __dirname,'..','node_modules','.bin','electroshot'
ERR = chalk.bgRed.white 'ERR'


module.exports = (settings)-> if not settings.image then Promise.resolve() else
	htmlFile = path.join settings.dest,"#{settings.fontName}.html"

	Promise.resolve()
		.then ()-> fs.inspectAsync(electroshot)
		.tapCatch ()-> console.error "#{ERR} Failed to generate image preview because 'electroshot' dependency couldn't be found"
		.then ()-> exec(electroshot, [htmlFile, "500x", "--selector", "'.table'", "--out", settings.dest, "--format", "png"])
		.tapCatch (err)-> console.error err
		.catch (err)-> console.error "#{ERR} Failed to generate image preview, skipping..."
		






Promise = require 'bluebird'
path = require 'path'
chalk = require 'chalk'
exec = require 'execa'
fs = require 'fs-jetpack'
ERR = chalk.bgRed.white 'ERR'
electroshotPath = path.join 'electroshot','bin','electroshot.js'
electroshot = try require.resolve electroshotPath
### istanbul ignore next ###
electroshot ?= path.resolve 'node_modules', electroshotPath


module.exports = (settings)-> if not settings.image then Promise.resolve() else
	htmlFile = path.join settings.dest,"#{settings.fontName}.html"

	Promise.resolve()
		.then ()-> exec(electroshot, [htmlFile, "500x", "--selector", "'.table'", "--out", settings.dest, "--format", "png"])
		.tapCatch (err)-> console.error(err) if process.env.DEBUG
		.catch (err)-> console.error "#{ERR} Failed to generate image preview, skipping..."
		






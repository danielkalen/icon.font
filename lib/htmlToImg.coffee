Promise = require 'bluebird'
path = require 'path'
chalk = require 'chalk'
exec = require 'execa'
fs = require 'fs-jetpack'
ERR = chalk.bgRed.white 'ERR'
Pageres = require 'pageres'


module.exports = (settings)-> if not settings.image then Promise.resolve() else
	htmlFile = path.join settings.dest,"#{settings.fontName}.html"
	filename = "#{settings.fontName}-<%= size %><%= crop %>"

	Promise.resolve()
		.then ()->
			(new Pageres(launchOptions:{executablePath: process.env.PUPPETEER_EXECUTABLE_PATH}))
				.src(htmlFile, ["1000x1000"], {selector:'.table', filename})
				.dest(settings.dest)
				.run()

		.tapCatch (err)-> console.error(err) if process.env.DEBUG
		.catch (err)-> console.error "#{ERR} Failed to generate image preview, skipping..."
		






Promise = require 'bluebird'
fs = require 'fs-jetpack'
path = require 'path'
chalk = require 'chalk'
exec = require 'execa'
fs = require 'fs-jetpack'
ERR = chalk.bgRed.white 'ERR'

module.exports = (settings)-> if not settings.image then Promise.resolve() else
	captureWebsite = (await import('capture-website')).default
	htmlFile = path.join settings.dest, "#{settings.fontName}.html"
	output = path.join settings.dest, "#{settings.fontName}-1000x1000.png"

	Promise.resolve()
		.then(()-> captureWebsite.buffer(htmlFile, {
			width: 1000,
			height: 1000,
			delay: 0,
			timeout: 0,
			fullPage: true,
			element: '.table',
			scaleFactor: 1,
			type: 'png',
			launchOptions: {
				executablePath: process.env.CHROMIUM_PATH || process.env.PUPPETEER_EXECUTABLE_PATH
			}
		}))
		.then (screenshot)-> fs.writeAsync(output, screenshot)
		.tapCatch (err)-> console.error(err) if process.env.DEBUG
		.catch (err)-> console.error "#{ERR} Failed to generate image preview, skipping..."
		






Promise = require 'bluebird'
extend = require 'smart-extend'
path = require 'path'
fs = require 'fs-jetpack'

module.exports = (settings)->
	getConfigFile(settings.configFile).then (config)->
		config.lastCodepoint = settings.codepointRanges[0][0] - 1 if not config.lastCodepoint

		for file in settings.iconFiles
			file = path.basename(file, '.svg')
			
			if not config.icons[file]
				config.icons[file] = genCodepoint(config, settings)


		if not settings.saveConfig
			return config
		else
			fs.writeAsync(settings.configFile, JSON.stringify(config, null, 2))
				.then ()-> return config






getConfigFile = (configFilePath)->
	fs.readAsync(configFilePath)
		.then (contents)-> JSON.parse(contents)
		.catch ()-> {lastCodepoint:null, icons:{}}


genCodepoint = (config, settings)->
	lastPoint = config.lastCodepoint
	newPoint = ++config.lastCodepoint
	lastRange = settings.codepointRanges.find (range)-> range[0]-1 <= lastPoint <= range[1]

	if newPoint <= lastRange[1]
		return newPoint
	else
		lastRangeIndex = settings.codepointRanges.indexOf(lastRange)
		newRange = settings.codepointRanges[lastRangeIndex+1]

		if not newRange
			throw new Error "Ran out of codepoint ranges (last range: #{lastRange.join ' - '})"

		return config.lastCodepoint = newRange[0]
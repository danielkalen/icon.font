Promise = require 'bluebird'
promiseBreak = require 'promise-break'
extend = require 'smart-extend'
path = require 'path'
fs = require 'fs-jetpack'

module.exports = (settings)->
	Promise.resolve(settings.configFile)
		.then getConfigFile
		.then (config)-> [config, settings]
		.spread normalizeConfig
		.then (config)->
			for file in settings.iconFiles
				file = path.basename(file, '.svg')
				
				if not config.icons[file]
					config.icons[file] = nextCodepoint(config, settings.codepointRanges)


			if not settings.saveConfig
				return config
			else
				fs.writeAsync(settings.configFile, JSON.stringify(config, null, 2))
					.then ()-> return config






getConfigFile = (target)->
	Promise.resolve()
		.then ()-> fs.existsAsync target
		.then (exists)-> promiseBreak() if not exists
		.then ()-> fs.readAsync target, 'json'

		.catch promiseBreak.end
		.then (config)-> config or {}


normalizeConfig = (config, settings)->
	config.lastCodepoint ?= null
	config.icons ?= {}
	icons = Object.keys(config.icons)
	ranges = settings.codepointRanges

	for icon in icons
		value = config.icons[icon]
		if typeof value is 'string'
			config.icons[icon] = value = value.codePointAt(0)
		
		if typeof value isnt 'number'
			throw new Error "invalid code point value for '#{icon}' in config file (value:#{value})"

	if not config.lastCodepoint
		if not icons.length
			config.lastCodepoint = ranges[0][0] - 1
		else
			icons = icons.map (icon)-> [icon, config.icons[icon]]
			config.lastCodepoint = getLastCodePoint(icons, ranges)

	return config

getLastCodePoint = (icons, ranges)->
	max = value:0, rangeIndex:-1
	
	for icon in icons
		range = matchRange(icon[1], ranges)
		rangeIndex = ranges.indexOf(range)
		
		if rangeIndex > max.rangeIndex
			max.value = icon[1]
			max.rangeIndex = rangeIndex
		
		else if rangeIndex is max.rangeIndex
			max.value = icon[1] if icon[1] > max.value

	return max.value


matchRange = (value, ranges)->
	ranges.find (range)-> range[0]-1 <= value <= range[1]


nextCodepoint = (config, ranges)->
	lastPoint = config.lastCodepoint
	newPoint = ++config.lastCodepoint
	lastRange = matchRange(lastPoint, ranges)

	if newPoint <= lastRange[1]
		return newPoint
	else
		lastRangeIndex = ranges.indexOf(lastRange)
		newRange = ranges[lastRangeIndex+1]

		if not newRange
			throw new Error "Ran out of codepoint ranges (last range: #{lastRange.join ' - '})"

		return config.lastCodepoint = newRange[0]




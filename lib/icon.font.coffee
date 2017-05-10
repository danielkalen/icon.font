Promise = require 'bluebird'
configGenerator = require './configGenerator'
htmlToImg = require './htmlToImg'
defaults = require './defaults'
iconBuilder = Promise.promisify require 'webfonts-generator'
extend = require 'smart-extend'
path = require 'path'
fs = require 'fs-jetpack'

module.exports = (settings)->
	settings = extend.deep.notDeep('types').clone(defaults, settings)
	settings.html = settings.css = true if settings.image
	settings.configFile = path.resolve(settings.src,'_icon-config.json') if settings.src isnt defaults.src and settings.configFile is defaults.configFile
	settings.templateOptions.previewSize = settings.previewSize

	fs.listAsync(settings.src).then (files)->
		settings.allFiles = files
		settings.iconFiles = files
			.filter (file)-> not file.startsWith('.') and file.endsWith('.svg')

		console.log 'Preparing config file...' unless settings.silent
		configGenerator(settings).then (config)->
			settings.files = Object.keys(config.icons).map (icon)-> path.join(settings.src, "#{icon}.svg")
			settings.codepoints = config.icons
			settings.templateOptions.iconValues = new ()->
				for key,codepoint of config.icons
					@[key] =
						'char': String.fromCharCode(codepoint)
						'html': if codepoint <= 0x7F then String.fromCharCode(codepoint) else '&#x'+codepoint.toString(16)+';'
						'css': if codepoint <= 0x7F then String.fromCharCode(codepoint) else '\\'+codepoint.toString(16)
				
				return @


			console.log 'Generating icon fonts...' unless settings.silent
			iconBuilder(settings).then ()->
				
				console.log 'Generating image preview...' unless settings.silent
				htmlToImg(settings).then ()->
					Promise.all([
						fs.removeAsync(path.resolve settings.dest, "#{settings.fontName}.html") unless settings.outputHtml
						fs.removeAsync(path.resolve settings.dest, "#{settings.fontName}.css") unless settings.outputCss
					]).then ()-> console.log 'Done' unless settings.silent








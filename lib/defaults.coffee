path = require 'path'

module.exports =
	'fontName': 'iconfont'
	'src': path.resolve('src')
	'dest': path.resolve('dest')
	'configFile': path.resolve('src','_icon-config.json')
	'previewSize': 18
	'saveConfig': true
	'image': true
	'html': true
	'htmlTemplate': path.join(__dirname,'templates','html.hbs')
	'outputHtml': true
	'css': true
	'cssTemplate': path.join(__dirname,'templates','css.hbs')
	'outputCss': true
	'fixedWidth': true
	'normalize': true
	'silent': true
	'types': ['woff2', 'woff', 'ttf', 'eot', 'svg']
	'templateOptions':
		classPrefix: '_icon-'
		baseSelector: '._icon'
		baseClassname: '_icon'
	'codepointRanges': [
		[97,122] # a-z
		[65,90] # A-Z
		[48,57] # 0-9
		[0xe001, Infinity]
	]

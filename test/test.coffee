Promise = require 'bluebird'
# Promise.config longStackTraces:true
fs = require 'fs-jetpack'
path = require 'path'
chalk = require 'chalk'
mocha = require 'mocha'
chai = require 'chai'
expect = chai.expect
iconFont = if process.env.forCoverage then require('../forCoverage/icon.font.js') else require('../')



suite "icon.font", ()->
	setup ()-> 
		fs.copyAsync('samples', 'src')
	
	teardown ()-> Promise.all [
		fs.removeAsync('src')
		fs.removeAsync('dest')
	]


	test "Can be invoked without arguments and will use default options to generate fonts", ()->
		iconFont().then ()-> fs.listAsync('dest').then (files)->
			files.splice(files.indexOf('.DS_Store'), 1) if files.includes('.DS_Store')
			expect(files).to.eql [
				'iconfont-500x0.png'
				'iconfont.css'
				'iconfont.eot'
				'iconfont.html'
				'iconfont.svg'
				'iconfont.ttf'
				'iconfont.woff'
				'iconfont.woff2'
			]

	test "HTML and CSS files can be omitted", ()->
		iconFont(outputHtml:false, outputCss:false).then ()-> fs.listAsync('dest').then (files)->
			files.splice(files.indexOf('.DS_Store'), 1) if files.includes('.DS_Store')
			expect(files).to.eql [
				'iconfont-500x0.png'
				'iconfont.eot'
				'iconfont.svg'
				'iconfont.ttf'
				'iconfont.woff'
				'iconfont.woff2'
			]
	

	test "Image preview file can be omitted", ()->
		iconFont(image:false).then ()-> fs.listAsync('dest').then (files)->
			files.splice(files.indexOf('.DS_Store'), 1) if files.includes('.DS_Store')
			expect(files).to.eql [
				'iconfont.css'
				'iconfont.eot'
				'iconfont.html'
				'iconfont.svg'
				'iconfont.ttf'
				'iconfont.woff'
				'iconfont.woff2'
			]


	test "A custom name can be set for the generated font", ()->
		iconFont(fontName:'myFont').then ()-> fs.listAsync('dest').then (files)->
			files.splice(files.indexOf('.DS_Store'), 1) if files.includes('.DS_Store')
			expect(files).to.eql [
				'myFont-500x0.png'
				'myFont.css'
				'myFont.eot'
				'myFont.html'
				'myFont.svg'
				'myFont.ttf'
				'myFont.woff'
				'myFont.woff2'
			]
	

	test "Only specific font types can be generated if specified, but svg will never be omitted", ()->
		iconFont(types:['woff','ttf'], image:false).then ()-> fs.listAsync('dest').then (files)->
			files.splice(files.indexOf('.DS_Store'), 1) if files.includes('.DS_Store')
			expect(files).to.eql [
				'iconfont.css'
				'iconfont.html'
				'iconfont.svg'
				'iconfont.ttf'
				'iconfont.woff'
			]


	test "A specific src/dest can be specified", ()->
		fs.copyAsync('samples', 'src2', overwrite:true).then ()->
			iconFont(src:'src2', dest:'dest2', image:false).then ()-> fs.listAsync('dest2').then (files)->
				files.splice(files.indexOf('.DS_Store'), 1) if files.includes('.DS_Store')
				expect(files).to.eql [
					'iconfont.css'
					'iconfont.eot'
					'iconfont.html'
					'iconfont.svg'
					'iconfont.ttf'
					'iconfont.woff'
					'iconfont.woff2'
				]

			.then ()-> Promise.all [
				fs.removeAsync('src2')
				fs.removeAsync('dest2')
			]


	test "A config file will be created for later reuse in the src dir", ()->
		fs.listAsync('src').then (files)->
			expect(files).not.to.contain('_icon-config.json')
			
			iconFont().then ()-> fs.listAsync('src').then (files)->
				expect(files).to.contain('_icon-config.json')
				json = require './src/_icon-config.json'

				expect(typeof json.lastCodepoint).to.equal 'number'
				expect(typeof json.icons).to.equal 'object'
				expect(json.icons['book']).to.equal 97
				expect(json.icons['notepad']).to.equal 98
				expect(json.icons['overview']).to.equal 99
				expect(json.icons['review']).to.equal 100


	# test "", ()->


	
	# test "", ()->









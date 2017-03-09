# icon.font
[![Build Status](https://travis-ci.org/danielkalen/icon.font.svg?branch=master)](https://travis-ci.org/danielkalen/icon.font)
[![Coverage](.config/badges/coverage-node.png?raw=true)](https://github.com/danielkalen/icon.font)
[![Code Climate](https://codeclimate.com/github/danielkalen/icon.font/badges/gpa.svg)](https://codeclimate.com/github/danielkalen/icon.font)
[![NPM](https://img.shields.io/npm/v/icon.font.svg)](https://npmjs.com/package/icon.font)

#### Features:
- Takes all SVG icons in a directory and generates icon fonts in .woff2, .woff, .ttf, .eot, and .svg formats.
- Generates an HTML preview containing the icons and their corresponding char mappings in both HTML and CSS syntax.
- Generates a PNG preview for the icon mapping.
- Support for persistent icon-unicode mapping by generating/using a config.json file in the source directory which will be used for any future webfont generations. This allows icon.font to remember the unicode mapping for icons processed in the past while allowing new icons to be added without offsetting the mapping.
- Assigns each icon a unique unicode char with the following ranges:
    - 'a' to 'z'
    - 'A' to 'Z'
    - '0' to '9'
    - '0xE001' to Infinity

# Command Line
```
Usage: icon.font [options]

Options:

    -h, --help              output usage information
    -V, --version           output the version number
    -s --src [path]         Path of dir containing SVG icon files [default: ./src]
    -d --dest [path]        Path of dir that the generated font files should be written to [default: ./dest]
    -f --fontName [name]    Name to assign to the generated icon font [default: iconfont]
    -c --configFile [path]  Path of the file containing the icon config [default: ./src/_icon-config.json]
    -t --type [path]        Font file types to generate (specifiy multiple times for multiple types) [default: woff2,woff,ttf,eot,svg]
    -S --silent             Normalize icons by scaling them to the height of the highest icon [default: false]
    --no-css                Avoid generating a css file [default: true]
    --no-html               Avoid generating an html preview [default: true]
    --no-image              Avoid generating an image preview [default: true]
    --no-saveConfig         Avoid saving the generated config file to disk [default: true]
    --no-fixedHeight        Normalize icons by scaling them to the height of the highest icon [default: true]
```


# API
```javascript
require('icon.font')({ // Default options
    fontName: 'iconfont',
    src: './src',
    dest: './dest',
    configFile: './src/_icon-config.json',
    saveConfig: true,
    image: true,
    html: true,
    htmlTemplate: '<module>/templates/html.hbs',
    outputHtml: true,
    css: true,
    cssTemplate: '<module>/templates/css.hbs',
    outputCss: true,
    fixedWidth: true,
    normalize: true,
    silent: true,
    types: ['woff2', 'woff', 'ttf', 'eot', 'svg'],
    templateOptions:
        classPrefix: '_icon-',
        baseSelector: '._icon',
        baseClassname: '_icon',
    codepointRanges: [
        [97,122] # a-z
        [65,90] # A-Z
        [48,57] # 0-9
        [0xe001, Infinity]
    ]
}).then(function(){
    // Finished
})
```



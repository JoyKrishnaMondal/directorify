browserify = require "browserify"

fs = require "fs"

color = require "colors/safe"

chokidar = require "chokidar"

delimit = (require 'path').sep

{ShowList,CopyDefaults,minDefaults} = require "node-helpers"

{SeparateFilesAndDir} = require "SeparateFilesAndDirectories"

lo = require "lodash"

colors = require "colors"

babelify = require "babelify"

pathResolve = (require "path").resolve

ErrorMain = (ConfigFileName) -> "Error: 'directorify' key is not populated in #{ConfigFileName}, please check docs for help."

log = (string,replace)->

	if replace == false
		console.log string
		return

	process.stdout.clearLine!
	process.stdout.cursorTo 0
	process.stdout.write string

	return

isDirectory = (path_string) -> fs.lstatSync(path_string).isDirectory!


Compile = (Options) -> ->

	{yellow,green,red} = colors

	{directorify} = Options

	if Options.browserify is undefined

		Options.browserify = {}

	b = browserify (directorify.inputFile),Options.browserify

	if not (Options.babelify is undefined)

		b = b.transform babelify,Options.babelify

	b = b.exclude directorify.exclude

	problem,buff <-! b.bundle

	if problem

		log yellow "Browserify: " + red problem.toString! + "\n"

		return
	
	problem <-! fs.writeFile directorify.saveFile,buff.toString!


	if problem

		console.error red problem

		return


	Text = yellow "directorify|:" + green directorify.count + yellow "| "  + green directorify.inputFile +  yellow " -> " + green directorify.saveFile

	log Text
	


	directorify.count += 1

	return


Main = (Options) ->

	{directorify} = Options

	{Files} <-! SeparateFilesAndDir directorify.source

	RegEx = new RegExp "(.*)\." + directorify.Ext

	JustFiles = []

	for I in Files

		Anly = RegEx.exec I

		if Anly

			JustFiles.push Anly[1]

	Fn = Compile Options

	for I in JustFiles

		
		

		watcher = chokidar.watch pathResolve (directorify.compile + delimit + I + directorify.Target)

		watcher.on "change",Fn

	Fn!

	return


{isString,isNumber} = lo


AssumedDir = (type:isString,value:"./")

Defaults =
	*inputFile:(type:isString)
		saveFile:(type:isString)
		source:AssumedDir
		compile:AssumedDir
		exclude:
			type:isString
			value:""
		Ext:
			type:isString
			value:"ls"
		Target:
			type:isString
			value:".js"
		count:
			type:isNumber
			value:0



if require.main is module

	InputLen = process.argv.length

	switch InputLen

	| 2 =>

		ConfigFile = "package.json"

	| 3 =>

		ConfigFile = process.argv[2]

	Options = JSON.parse fs.readFileSync ConfigFile,(encoding:'utf8')

	if Options.directorify is undefined

		console.log colors.red ErrorMain ConfigFile

	else

		minDefaults Options.directorify,Defaults

		Main Options

else

	module.exports = Main

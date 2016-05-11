SuperDuplicate = null

module.exports =

	activate: ->
		@commands = atom.commands.add 'atom-workspace',
		'super-duplicate:duplicate': =>
			@loadModule()
			SuperDuplicate.duplicate()

	deactivate: ->
		@commands.dispose()
		SuperDuplicate = null
		return

	loadModule: ->
		SuperDuplicate ?= require './super-duplicate'

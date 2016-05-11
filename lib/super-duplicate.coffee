class SuperDuplicate

	entries = {
		"x":"y"
		"X":"Y"
		"w":"h"
		"W":"H"
		"width":"height"
		"WIDTH":"HEIGHT"
		"scaleX":"scaleY"
		"radiusX":"radiusY"
		"true":"false"
		"right":"left"
		"RIGHT":"LEFT"
		"front":"back"
		"FRONT":"BACK"
		"up":"down"
		"UP":"DOWN"
		"open":"close"
		"OPEN":"CLOSE"
		"add":"remove"
		"ADD":"REMOVE"
		"addEventListener":"removeEventListener"
	}

	regexps = []

	for key, value of entries
		r = new RegExp("\\b("+key+"|"+value+")\\b","g")
		regexps.push {value1:key,value2:value,regex:r}

	duplicate: (@editor=atom.workspace.getActiveTextEditor()) ->
		return unless @editor?

		checkpoint = @editor.createCheckpoint()
		@editor.selectLinesContainingCursors()
		ranges = @editor.getSelectedBufferRanges()
		@editor.duplicateLines()

		y = 0
		for range in ranges
			y+=range.getRowCount()-1
			range.start.row+=y
			range.end.row+=y
			@editor.setSelectedBufferRange(range)

			for r in regexps
				@editor.backwardsScanInBufferRange(r.regex,range,({match,replace})=>
					v = if (match[0]==r.value1) then r.value2 else r.value1
					replace(v)
				)
		@editor.groupChangesSinceCheckpoint(checkpoint)
		return

module.exports = new SuperDuplicate()

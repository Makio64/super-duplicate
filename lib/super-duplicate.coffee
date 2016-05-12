class SuperDuplicate

	entries = {
		"x":["y","z","w"]
		"X":["Y","Z","W"]
		"w":["h","d"]
		"W":["H","D"]
		"width":["height","depth"]
		"WIDTH":["HEIGHT","DEPTH"]
		"scaleX":["scaleY","scaleZ","scaleW"]
		"radiusX":["radiusY","radiusZ","radiusW"]
		"r":["g","b","a"]
		"R":["G","B","A"]
		"true":["false"]
		"right":["left"]
		"RIGHT":["LEFT"]
		"front":["back"]
		"FRONT":["BACK"]
		"up":["down"]
		"UP":["DOWN"]
		"open":["close"]
		"OPEN":["CLOSE"]
		"add":["remove"]
		"ADD":["REMOVE"]
		"addEventListener":["removeEventListener"]
	}

	regexps = []

	for key, value of entries
		r = new RegExp("\\b("+key+"|"+value[0]+")\\b","g")
		regexps.push {value1:key,value2:value[0],regex:r,level:0}
		for i in [0...value.length-1]
			r = new RegExp("\\b("+value[i]+"|"+value[i+1]+")\\b","g")
			regexps.push {value1:value[i],value2:value[i+1],regex:r,level:1+i}

	currentLevel = 0
	lastDuplicateTime = 0

	duplicate: (@editor=atom.workspace.getActiveTextEditor()) ->
		return unless @editor?

		checkpoint = @editor.createCheckpoint()
		@editor.selectLinesContainingCursors()
		ranges = @editor.getSelectedBufferRanges()
		@editor.duplicateLines()

		if(Date.now()-lastDuplicateTime<300)
			currentLevel++
			currentLevel%=3
		else
			currentLevel=0

		lastDuplicateTime = Date.now()

		y = 0
		for range in ranges
			y+=range.getRowCount()-1
			range.start.row+=y
			range.end.row+=y
			@editor.setSelectedBufferRange(range)

			for r in regexps
				if(r.level!=currentLevel)
					continue
				@editor.backwardsScanInBufferRange(r.regex,range,({match,replace})=>
					v = if (match[0]==r.value1) then r.value2 else r.value1
					replace(v)
				)
		@editor.moveLeft()
		@editor.groupChangesSinceCheckpoint(checkpoint)
		return

module.exports = new SuperDuplicate()

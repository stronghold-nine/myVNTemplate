extends RichTextLabel

onready var timer = $Timer
onready var autoTimer = $autoTimer
var autoCounter = 0
var skipCounter = 0
var display_dialog = ''
var adding = false
var nw = false

signal load_next

func _ready():
	autoTimer.start()

func set_dialog(words : String, cps = vn.cps):
	self.bbcode_text = "" # always clear it when new dialog is happening
	nw = false
	display_dialog = preprocess(words)
	self.visible_characters = 0
	self.bbcode_text = display_dialog
	
	match cps:
		25: timer.wait_time = 0.04
		0:
			self.visible_characters = -1
			adding = false
			if nw:
				nw = false
				emit_signal("load_next")
			return
		10: timer.wait_time = 0.1
		_: timer.wait_time = 0.02
		
	adding = true
	timer.start()
	
func force_finish():
	if adding:
		self.visible_characters = -1
		adding = false
		timer.stop()
		if nw:
			nw = false
			emit_signal("load_next")

func _on_Timer_timeout():
	self.visible_characters += 1
	if self.visible_characters >= self.text.length():
		adding = false
		timer.stop()
		if nw:
			nw = false
			emit_signal("load_next")

func preprocess(words : String) -> String:
	# preprocess the input to see if there are any special things
	# I think this is a good idea because for dialog, the sentences
	# won't be too long.
	var leng = words.length()
	var output = ''
	var i = 0
	while i < leng:
		var c = words[i]
		var inner = ""
		if c == '[':
			i += 1
			while words[i] != ']':
				inner += words[i]
				i += 1
				if i >= leng:
					vn.error("Please do not use square brackets " +\
					"unless for bbcode and display dvar purposes.")
					
			match inner:
				"nw": 
					if not vn.skipping:
						self.nw = true
				_: 
					if check_dvar(inner):
						output += str(vn.dvar[inner])
					else:
						output += '[' + inner + ']'
						
		else:
			output += c
			
		i += 1
	
	return output

# Call this after set_dialog, to get parsed words. (Pvars will be parsed
# into text.)
func get_text():
	return self.bbcode_text


func check_dvar(vname : String) -> bool:
	if vn.dvar.has(vname):
		return true
	else:
		return false


func _on_autoTimer_timeout():
	if vn.skipping:
		skipCounter = (skipCounter + 1)%2
		if skipCounter == 1:
			emit_signal("load_next")
	else:
		if not adding and vn.auto_on: 
			autoCounter += 1
			if autoCounter >= vn.auto_bound:
				autoCounter = 0
				if not nw:
					emit_signal("load_next")
	
		else:
			autoCounter = 0

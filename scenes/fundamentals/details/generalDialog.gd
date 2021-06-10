extends Node2D
class_name generalDialog
export(bool) var debug_mode
# preloading
var choiceBar = preload("res://scenes/fundamentals/choiceBar.tscn")
var bottomLayer = preload("res://scenes/fundamentals/details/bottomLayerRect.tscn")

var current_dialog = ""
var current_index = 0
var current_block = null
var all_blocks = null
var all_choices = null
var nvl = false
var centered = false
var waiting_acc = false
var waiting_cho = false
var just_loaded = false
const cps_dict = {'fast':50, 'slow':25, 'instant':0, 'slower':10}
const arith_symbols = ['>','<', '=', '!', '+', '-', '*', '/', '%']
onready var bg = $background
onready var vnui = $VNUI
onready var QM = vnui.get_node('quickMenu')
onready var nvlBox = vnui.get_node('nvlBox')
onready var dialogbox = vnui.get_node('dialog')
onready var speaker = vnui.get_node('speaker')
# signals
signal player_accept

#--------------------------------- Intepretor ----------------------------------

func load_event_at_index(ind : int) -> void:
	intepret_events(current_block[ind])

func intepret_events(event):
	# Try to keep the code under each case <=3 lines
	# Also keep the number of cases small. Try to repeat the use of key words.
	if debug_mode: print("Debug :" + str(event))
	match event:
		{"condition", "then", "else",..}: conditional_branch(event)
		{"condition",..}:
			if check_condition(event['condition']):
				event.erase('condition')
				continue
			else: # condition fails.
				auto_load_next()
		{"fadein"}: fadein(event["fadein"])
		{"fadeout"}: fadeout(event["fadeout"])
		{"screen",..}: screen_effects(event)
		{"bg",..}: change_background(event)
		{"chara",..}: character_event(event)
		{"weather"}: change_weather(event)
		{"camera", ..}: 
			if vn.skipping:
				auto_load_next()
			else:
				camera_effect(event)
		{"express"}: express(event['express'])
		{"bgm",..}: play_bgm(event)
		{'audio'}: play_sound(event['audio'])
		{'dvar'}: set_dvar(event)
		{'font', 'path'}: change_font(event)
		{'sfx',..}: anim_player(event)
		{'then',..}: then(event)
		{'quick_menu'}: quick_menu(event)
		{'choice',..}: generate_choices(event)
		{'wait'}: wait(event['wait'])
		{'nvl'}: set_nvl(event)
		{'GDscene'}: change_scene_to(event['GDscene'])
		{'center'}:
			self.centered = true
			set_nvl({'nvl': true}, false)
			if event.has('speed'):
				say('', event['center'], event['speed'])
			else:
				say('', event['center'])
		_: speech_parse(event)
				
			
#----------------------- on ready, new game, load, set up, end -----------------
func start_scene(blocks : Dictionary, choices: Dictionary, load_instruction : String) -> void:
	all_blocks = blocks
	all_choices = choices
	dialogbox.connect('load_next', self, 'trigger_accept')
	nvlBox.connect('load_next', self, 'trigger_accept')
	if load_instruction == "new_game":
		current_index = 0
		current_block = blocks['starter'] # this is an array of events
		game.currentIndex = 0
		game.currentBlock = 'starter' # this is the name corresponding to the array
	elif load_instruction == "load_game":
		current_index = game.currentIndex
		current_block = blocks[game.currentBlock]
		load_playback(game.playback_events)
	else:
		vn.error('Unknown loading instruction.')
	
	if debug_mode:
		print("Debug: current block is " + game.currentBlock)
		print("Debug: current index is " + str(current_index))
	load_event_at_index(current_index)
	

func auto_load_next():
	current_index += 1
	game.currentIndex = current_index
	if debug_mode: print("Debug: current event index is " + str(current_index))
	load_event_at_index(current_index)

func scene_end():
	pass
#------------------------ Related to Dialog Progression ------------------------
func set_nvl(ev: Dictionary, auto_forw = true):
	if typeof(ev['nvl']) == 1:
		self.nvl = ev['nvl']
		if self.nvl:
			nvl_on()
		else:
			nvl_off()
		
		if auto_forw: auto_load_next()
		return
	elif ev['nvl'] == 'clear':
		nvlBox.clear()
		if auto_forw: auto_load_next()
	else:
		vn.error('nvl expects a boolean or the keyword clear.', ev)
	

func speech_parse(ev : Dictionary) -> void:
	var combine = "NANITHEFUCK"
	for k in ev.keys(): # None voice, none speed, means it has to be "uid expression"
		if k != 'voice' and k != 'speed':
			combine = k # combine=unique_id and expression combined
			break
			
	if combine == 'NANITHEFUCK': # Otherwise, error
		vn.error("Speech event requires a key that is of the form 'uid expression'." ,ev)
	
	if ev.has('speed'):
		if (ev['speed'] in cps_dict.keys()):
			say(combine, ev[combine], cps_dict[ev['speed']])
		else:
			say(combine, ev[combine])
	else:
		say(combine, ev[combine])
				
	if ev.has('voice') and not vn.skipping:
		voice(ev['voice'])


func generate_choices(event: Dictionary):
	# make a say event
	if self.nvl:
		nvl_off()
	if vn.auto_on or vn.skipping:
		QM.reset_skip() 
		QM.reset_auto()
	waiting_cho = true
	if event.has('voice'):
		voice(event['voice'])
	var combine = ""
	for k in event.keys():
		if k != 'id' and k != 'choice' and k != 'voice':
			combine = k
			break
	if combine != "":
		say(combine, event[combine], 0, true)
		
	var options = all_choices[event['choice']]
	for i in options.size():
		var ev = options[i]
		if ev.size()>2 : 
			vn.error('Only size 1 or 2 dict will be accepted as choice.')
		elif ev.size() == 2:
			if ev.has('condition'):
				if not check_condition(ev['condition']):
					continue # skip to the next one if condition not met
			else:
				vn.error('If a choice is size 2, then it has to have a condition.')
					
		var choice_text = ""
		for k in ev.keys():
			if k != "condition":
				choice_text = k # grap the key not equal to condition
				break
					
		var choice_ev = ev[choice_text] # the choice action
		var choice = choiceBar.instance()
		choice.setup_choice_event(choice_text, choice_ev)
		choice.connect("choice_made", self, "on_choice_made")
		vnui.get_node('choiceContainer').add_child(choice)
		# waiting for user choice
	
func say(combine : String, words : String, cps = vn.cps, ques = false) -> void:
	var temp = combine.split(" ") # temp[0] = uid, temp[1] = expression
	var speaking_chara = null
	if chara.all_chara.has(temp[0]):
		speaking_chara = chara.all_chara[temp[0]]
	else:
		vn.error("Character not found.")
	
	if temp.size() == 2: # Characters not on stage is still able to talk.
		# Only that their sprite won't be shown. And this will be pointless.
		chara.all_chara[temp[0]].change_expression(temp[1])
			
	if vn.skipping: cps = 0
	waiting_acc = true
	if self.nvl:
		if just_loaded:
			just_loaded = false
			if centered:
				nvlBox.set_dialog(temp[0], words, cps)
			else:
				nvlBox.visible_characters = nvlBox.text.length()
		else:
			nvlBox.set_dialog(temp[0], words, cps)
			if centered: 
				game.nvl_text = ''
			else:
				game.nvl_text = nvlBox.bbcode_text
			game.history.push_back([temp[0], nvlBox.get_text()])
	else:
		speaker.set("custom_colors/default_color", speaking_chara.default_color)
		speaker.bbcode_text = speaking_chara.display_name
		dialogbox.set_dialog(words, cps)
		if just_loaded:
			just_loaded = false
		else:
			game.history.push_back([temp[0], dialogbox.get_text()])
		
		stage.set_highlight(temp[0])
		
	# wait for ui_accept if this is not a question
	if not ques:
		yield(self, "player_accept")
		music.stop_voice()
		if centered:
			nvl_off()
			centered = false
		if not self.nvl: stage.remove_highlight()
		waiting_acc = false
		auto_load_next()
	
	# If this is a question, then displaying the text is all we need.

func _input(ev):
	if waiting_cho:
		# Waiting for a choice. Do nothing. Any input will be nullified.
		# In a choice event, game resumes only when a choice button is selected.
		return
	
	if ev.is_action_pressed("ui_accept") and waiting_acc:
		if ev is InputEventMouseButton:
			if vn.auto_on or vn.skipping:
				if not vn.noMouse:
					QM.reset_auto()
					QM.reset_skip()
				else:
					return
			else:
				if not vn.noMouse and not vn.inNotif and not vn.inSetting:
					check_dialog()
		else: # non mouse
			if vn.auto_on or vn.skipping:
				QM.reset_auto()
				QM.reset_skip()
			elif not vn.inNotif and not vn.inSetting:
				check_dialog()
				
	
func change_font(ev : Dictionary):
	var path = ev['path']
	if fileRelated.path_valid(path):
		match ev['font']:
			'normal':
				dialogbox.add_font_override("normal_font", load(path))
				nvlBox.add_font_override("normal_font", load(path))
			'bold':
				dialogbox.add_font_override("bold_font", load(path))
				nvlBox.add_font_override("bold_font", load(path))
			'italics':
				dialogbox.add_font_override("bold_font", load(path))
				nvlBox.add_font_override("bold_font", load(path))
			'bold_italics':
				dialogbox.add_font_override("bold_font", load(path))
				nvlBox.add_font_override("bold_font", load(path))
			'mono':
				dialogbox.add_font_override("mono_font", load(path))
				nvlBox.add_font_override("mono_font", load(path))
			_: vn.error("Unknown font style (Use normal, bold, italics, bold_italics or mono.).", ev)
			
		auto_load_next()
	else:
		vn.error("p", ev)
	
#------------------------ Related to Music and Sound ---------------------------
func play_bgm(ev : Dictionary) -> void:
	var path = ev['bgm']
	if path == "" and ev.size() == 1:
		music.stop_bgm()
		game.playback_events['bgm'] = {}
		auto_load_next()
		return
		
	# Deal with fadeout first
	if path == "" and ev.size() > 1: # must be a fadeout
		if ev.has('fadeout'):
			music.fadeout(ev['fadeout'])
			game.playback_events['bgm'] = {}
			auto_load_next()
			return
		else:
			vn.error('If fadeout is intended, please supply a time. Otherwise, unknown '+\
			'keyword format.', ev)
			
	# Now we're sure it's either play bgm or fadein bgm
	var vol = 0
	if ev.has('vol'): vol = ev['vol']
	var music_path = vn.BGM_DIR + path
	if fileRelated.path_valid(music_path):
		if ev.size() == 1: # only a path is provided
			music.play_bgm(music_path, vol)
			game.playback_events['bgm'] = ev
			if !vn.inLoading:
				auto_load_next()
			return
			
		if ev.has('fadein'):
			music.fadein(music_path, ev['fadein'], vol)
			game.playback_events['bgm'] = ev
			if !vn.inLoading:
				auto_load_next()
			return
		else:
			vn.error('If fadein is intended, please supply a time. Otherwise, unknown '+\
			'keyword format.', ev)
	else:
		vn.error('p', ev)
	
func play_sound(path : String) -> void:
	var audio_path = vn.AUDIO_DIR + path
	if fileRelated.path_valid(audio_path):
		music.play_sound(audio_path)
		auto_load_next()
	else:
		vn.error("p")
		
func voice(path:String) -> void:
	var voice_path = vn.VOICE_DIR + path
	if fileRelated.path_valid(voice_path):
		music.play_voice(voice_path)
		# DO NOT AUTO LOAD FOR VOICE BECAUSE VOICE ONLY COMES
		# FROM SPEECH EVENT OR CHOICE EVENT
	else:
		vn.error('p')
#------------------- Related to Background and Godot Scene Change ----------------------
func change_background(ev : Dictionary) -> void:
	var path = ev['bg']
	if ev.size() == 1 or vn.skipping or vn.inLoading:
		bg_change(path)
	elif ev.has('fade'):
		var t = float(ev['fade'])
		fadeout(t/2, false)
		bg_change(path)
		fadein(t/2, false)
	elif ev.has('pixellate'):
		var t = float(ev['pixellate'])/2
		screenEffects.pixel_out(t)
		clear_boxes()
		hide_boxes()
		QM.visible = false
		yield(get_tree().create_timer(t), 'timeout')
		bg_change(path)
		screenEffects.pixel_in(t)
		yield(get_tree().create_timer(t), 'timeout')
		show_boxes()
		if not QM.hiding: QM.visible = true
	
	else:
		vn.error("Unknown bg transition effect.", ev)
	
	if !vn.inLoading:
		game.playback_events['bg'] = ev
		auto_load_next()

func change_scene_to(path : String):
	stage.remove_chara('absolute_all')
	music.stop_voice()
	QM.reset_auto()
	QM.reset_skip()
	var error = get_tree().change_scene(path)
	if error == OK:
		self.queue_free()
	else:
		vn.error('p')

#------------------------------ Related to Dvar --------------------------------
func set_dvar(ev : Dictionary) -> void:
	var parsed = split_condition(ev['dvar'])
	var front_var = parsed[0]
	var arith = parsed[1]
	var back_var = parsed[2]
	
	# Takes the value of a dvar if back_var corresponds to a dvar
	# Or if it is a float, then parse it to a float
	back_var = dvar_or_float(back_var)
	if not has_dvar(front_var) and arith != "=":
		vn.error('The variable at front must be a dvar.', ev)
	
	match arith:
		"=": vn.dvar[front_var] = back_var
		"+=": vn.dvar[front_var] += back_var
		"-=": vn.dvar[front_var] -= back_var
		"*=": vn.dvar[front_var] *= back_var
		"/=": vn.dvar[front_var] /= back_var
		"%=": vn.dvar[front_var] %= back_var
		_: vn.error("Unknown arithmetic symbol " + arith, ev)
		
	auto_load_next()
	

func check_condition(cond : String) -> bool:
	var parsed = split_condition(cond)
	var front_var = parsed[0]
	var rel = parsed[1]
	var back_var = parsed[2]
	
	front_var = dvar_or_float(front_var)
	back_var = dvar_or_float(back_var)

	var result = false
	
	match rel:
		"=": result = (front_var == back_var)
		"==": result = (front_var <= back_var)
		"<=": result = (front_var <= back_var)
		">=": result = (front_var >= back_var)
		"<": result = (front_var < back_var)
		">": result = (front_var > back_var)
		"!=": result = (front_var != back_var)
		_: vn.error('Relation ' + rel + ' invalid.')
	
	return result

#--------------- Related to transition and other screen effects-----------------
func screen_effects(ev: Dictionary):
	var ef = ev['screen']
	if typeof(ef) == 1 and ef == false:
		screenEffects.removeTint()
		# One lasting screen effect is allowed.
		game.playback_events['screen'] = {}
		auto_load_next()
		return
	
	# If we require more parameters, I would love to process the parameters
	# here. If there is no parameters like shockwave, then directly call it.
	match ef:
		"tint": tint(ev)
		_: vn.error('Unknown screen effect.' , ev)
	
	if !vn.inLoading:
		auto_load_next()

func quick_menu(ev: Dictionary):
	if ev['quick_menu']:
		QM.visible = true
		QM.hiding = false
	else:
		QM.visible = false
		QM.hiding = true
	auto_load_next()

func fadein(time : float, auto_forw = true) -> void:
	clear_boxes()
	show_boxes()
	QM.visible = false
	if not vn.skipping:
		screenEffects.fadein(time)
		yield(get_tree().create_timer(time), "timeout")
	
	QM.visible = true
	if auto_forw: auto_load_next()
	
func fadeout(time : float, auto_forw = true) -> void:
	clear_boxes()
	hide_boxes()
	QM.visible = false
	if not vn.skipping:
		screenEffects.fadeout(time)
		yield(get_tree().create_timer(time), "timeout")
	QM.visible = true
	show_boxes()
	if auto_forw: auto_load_next()

func tint(ev : Dictionary) -> void:
	
	if ev.has('time') and ev.has('color'):
		if ev.has('wave') and typeof(ev['wave']) == 1 and ev['wave']:
			screenEffects.tintWave(ev['color'], ev['time'])
		else:
			screenEffects.tint(ev['color'], ev['time'])
			
		game.playback_events['screen'] = ev
	else:
		vn.error("Tint requires color and time keywords, and one optional key wave.", ev)

# Sprite animations...
func anim_player(ev : Dictionary) -> void:
	var target_scene = load(ev['sfx']).instance()
	add_child(target_scene)
	if ev.has('loc'): target_scene.position = ev['loc']
	if ev.has('anim'):
		var anim = target_scene.get_node('AnimationPlayer')
		if anim.has_animation(ev['anim']):
			anim.play(ev['anim'])
			auto_load_next()
		else:
			vn.error('Animation not found.', ev)
	else: # Animation is not specified, that means it will automatically play
		auto_load_next()

func camera_effect(event : Dictionary) -> void:
	var ef_name = event['camera']
	match ef_name:
		"vpunch": screenEffects.vpunch()
		"hpunch": screenEffects.hpunch()
		"shake":
			if event.has("amount") and event.has("time"):
				screenEffects.shake(event['amount'], event['time'])
			else:
				vn.error("Shake expects an amount and time.", event)
		_:
			vn.error("Camera effect not found.", event)
			
	auto_load_next()
#----------------------------- Related to Character ----------------------------
func character_event(ev : Dictionary) -> void:
	# For character event, auto_load_next should be consider within
	# each individual method. Because some methods requires a yield
	# before auto_load_next.
	
	var temp = ev['chara'].split(" ")
	if temp.size() != 2:
		vn.error('Expecting a uid and an effect name separated by a space.', ev)
	var uid = temp[0] # uid of the character
	var ef = temp[1] # what character effect
	if uid == 'all' or stage.is_on_stage(uid):
		match ef: # jump and shake will be ignored during skipping
			"shake": 
				if vn.skipping : 
					auto_load_next()
				else:
					character_shake(uid, ev)
			"jump": 
				if vn.skipping : 
					auto_load_next()
				else:
					character_jump(uid, ev)
			'move': if uid != 'all': character_move(uid, ev)
			'fadeout': 
				if vn.skipping:
					stage.remove_chara(uid)
					auto_load_next()
				else:
					character_fadeout(uid,ev)
			'leave': stage.remove_chara(uid)
			_: vn.error('Unknown character event/action.', ev)
		
	else: # uid is not all, and character not on stage
		if ef == 'join':
			if ev.has('loc') and ev.has('expression'):
				join(uid, ev['loc'], ev['expression'])
			else:
				vn.error('Character join expects a loc and an expression.')
		elif ef == 'fadein':
			if vn.skipping:
				join(uid, ev['loc'], ev['expression'])
			else:
				character_fadein(uid, ev)
		else:
			vn.error('Unknown character event/action.', ev)	

func character_shake(uid:String, ev:Dictionary) -> void:
	if ev.has('amount') and ev.has('time'):
		stage.shake_chara(uid, ev['amount'], ev['time'])
		auto_load_next()
	else:
		vn.error('Character shake effect expects an amount and a time.', ev)

func join(uid : String, pos : Vector2, expression : String) -> void:
	if expression == "":
		expression = "default"
	
	var join_chara = chara.all_chara[uid]
	stage.add_child(join_chara)
	join_chara.on_stage = true
	if join_chara.change_expression(expression):
		join_chara.position = pos
		join_chara.loc = pos
		if !vn.inLoading:
			auto_load_next()
	else:
		vn.error(expression + " not found for character with unique id " + uid)

func express(combine : String) -> void:
	var temp = combine.split(" ")
	if temp.size() != 2:
		vn.error("Wrong express format.")
	# express only works for on stage charas
	stage.change_expression(temp[0],temp[1])
	auto_load_next()

func character_jump(uid : String, ev : Dictionary) -> void:
	if ev.has('amount') and ev.has('time') and ev.has('dir'):
		stage.jump(uid, ev['dir'], ev['amount'], ev['time'])
		auto_load_next()
	else:
		vn.error('Character jump expects an amount, a time and a dir (up, down, right, left).', ev)

func character_fadein(uid: String, ev:Dictionary):
	if ev.has('time') and ev.has('loc') and ev.has('expression'):
		stage.fadein(uid, ev['time'], ev['loc'], ev['expression'])
		yield(get_tree().create_timer(ev['time']), 'timeout')
		auto_load_next()
	else:
		vn.error('Character fadein expects a time, a loc, and an expression.', ev)

func character_fadeout(uid: String, ev:Dictionary):
	if ev.has('time'):
		stage.fadeout(uid, ev['time'])
		yield(get_tree().create_timer(ev['time']), 'timeout')
		auto_load_next()
	else:
		vn.error('Character fadeout expects a time.', ev)

func character_move(uid:String, ev:Dictionary):
	if ev.has('loc') and ev.has('type'):
		if ev['type'] == 'instant' or vn.skipping:
			stage.change_pos(uid, ev['loc'])
			auto_load_next()
		elif ev['type'] == 'linear':
			if ev.has('time'):
				stage.change_pos_linear(uid, ev['loc'], ev['time'])
				yield(get_tree().create_timer(ev['time']), 'timeout')
				auto_load_next()
			else:
				vn.error('Linear move expects a time.', ev)
		else:
			vn.error('Unknown movement type.', ev)
	else:
		vn.error("Character move expects a loc and a type. If type is linear, a time "+\
		"should be supplied.", ev)


#--------------------------------- Weather -------------------------------------
func change_weather(ev:Dictionary):
	var we = ev['weather']
	screenEffects.show_weather(we) # If given weather doesn't exist, nothing will happen
	if !vn.inLoading:
		if we == "":
			game.playback_events['weather'] = {}
		else:
			game.playback_events['weather'] = ev
		auto_load_next()


#--------------------------------- Utility -------------------------------------
func conditional_branch(ev : Dictionary) -> void:
	if check_condition(ev['condition']):
		change_block_to(ev['then'],0)
	else:
		change_block_to(ev['else'],0)

func then(ev : Dictionary) -> void:
	if ev.has('target id'):
		change_block_to(ev['then'], 1 + get_target_index(ev['then'], ev['target id']))
	else:
		change_block_to(ev['then'], 0)
		
func change_block_to(bname : String, bindex : int) -> void:
	if all_blocks.has(bname):
		current_block = all_blocks[bname]
		if bindex >= current_block.size():
			vn.error("Cannot go back to the last event of block " + bname + ".")
		else:
			game.currentBlock = bname
			game.currentIndex = bindex
			current_index = bindex 
			if debug_mode:
				print("Debug: current block is " + bname)
				print("Debug: current index is " + str(bindex))
			load_event_at_index(current_index)
	else:
		vn.error('Cannot find block with the name ' + bname)

func get_target_index(bname : String, target_id):
	for i in range(all_blocks[bname].size()):
		var d = all_blocks[bname][i]
		if d.has('id') and (d['id'] == target_id):
			return i
	vn.error('Cannot find event with id ' + target_id + ' in ' + bname)
	
func has_dvar(key : String) -> bool:
	if vn.dvar.has(key):
		return true
	else:
		return false

func check_dialog():
	if dialogbox.adding:
		dialogbox.force_finish()
	else:
		emit_signal("player_accept")

func hide_boxes():
	vnui.get_node('textBox').visible = false
	vnui.get_node('nameBox').visible = false

func show_boxes():
	vnui.get_node('textBox').visible = true
	vnui.get_node('nameBox').visible = true

func clear_boxes():
	speaker.bbcode_text = ''
	dialogbox.bbcode_text = ''

func wait(time : float) -> void:
	if vn.skipping:
		return
	if time >= 0.1:
		time = stepify(time, 0.1)
		yield(get_tree().create_timer(time), "timeout")
		auto_load_next()
	else:
		vn.error('Wait time has to be 0.1s or longer.')

func on_choice_made(ev : Dictionary) -> void:
	for n in vnui.get_node('choiceContainer').get_children():
		n.queue_free()
	
	waiting_cho = false
	if ev.size() == 0:
		auto_load_next()
	else:
		intepret_events(ev)

func load_playback(play_back):
	vn.inLoading = true
	if play_back['bg'].size() > 0:
		intepret_events(play_back['bg'])
	if play_back['bgm'].size() > 0:
		intepret_events(play_back['bgm'])
	if play_back['screen'].size() > 0:
		intepret_events(play_back['screen'])
	
	for d in play_back['charas']:
		var dkeys = d.keys()
		var loc = d['loc']
		dkeys.erase('loc')
		var uid = dkeys[0]
		intepret_events({'chara': uid + ' join', 'loc': loc, 'expression': d[uid]})
		
	if play_back['nvl'] != '':
		nvl_on()
		game.nvl_text = play_back['nvl']
		nvlBox.bbcode_text = game.nvl_text
	
	vn.inLoading = false
	just_loaded = true

func split_condition(line:String):
	var front_var = ''
	var back_var = ''
	var rel = ''
	var presymbol = true
	for i in line.length():
		var le = line[i]
		if le != " ":
			var is_symbol = le in arith_symbols
			if is_symbol:
				presymbol = false
				rel += le

			if not (is_symbol) and presymbol:
				front_var += le
				
			if not (is_symbol) and not presymbol:
				back_var += le
				
	return [front_var, rel, back_var]

func dvar_or_float(dvar:String):
	var output = 0
	if has_dvar(dvar):
		output = vn.dvar[dvar]
	elif dvar.is_valid_float():
		output = dvar.to_float()
	else:
		vn.error('Variable is not a dvar and is not a valid float.')
	return output

func nvl_off():
	show_boxes()
	dialogbox.get_node('autoTimer').start()
	nvlBox.visible = false
	nvlBox.clear()
	nvlBox.get_node('autoTimer').stop()
	get_node('background').modulate = Color(1,1,1,1)
	stage.set_modulate_4_all(Color(0.86,0.86,0.86,1))
	self.nvl = false

func nvl_on():
	if centered: nvl_off()
	clear_boxes()
	hide_boxes()
	dialogbox.get_node('autoTimer').stop()
	nvlBox.visible = true
	nvlBox.get_node('autoTimer').start()
	if centered:
		nvlBox.center_mode()
		get_node('background').modulate = Color(0.7,0.7,0.7,1)
		stage.set_modulate_4_all(Color(0.7,0.7,0.7,1))
	else:
		get_node('background').modulate = Color(0.2,0.2,0.2,1)
		stage.set_modulate_4_all(Color(0.2,0.2,0.2,1))
	
	self.nvl = true

func trigger_accept():
	if not waiting_cho:
		emit_signal("player_accept")

func bg_change(path: String):
	var bg_path = vn.BG_DIR + path
	if fileRelated.path_valid(bg_path):
		bg.texture = load(bg_path)
	else:
		vn.error("p")

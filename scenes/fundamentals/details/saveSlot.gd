extends Control
class_name saveSlot

signal save_made
signal load_ready

var mode = 0 # 0 means we are accessing it in safe screen
# 1 means we are accessing it in load screen

var raw_thumbnail_data = null
var path = ''

func _on_Button_pressed():
	if mode == 0: # if we are accessing this in the safe screen
		if self.path != '':
			notif.show("override")
			var override_choice = notif.get_current_notif()
			override_choice.connect("decision", self, "override_save")
		else:
			make_save(self.path)
			emit_signal("save_made")
	
	else: # we are accessing this in the load screen
		if self.path != '':
			var success = fileRelated.readSave(self)
			if success:
				emit_signal('load_ready')
			else:
				# warning, save loading failed
				vn.error('Loading failed. (Unknown reason.)')
		pass


#---------------------Functionalities Related to Save--------------------------

func override_save(yes):
	if yes:
		make_save(self.path)
	else:
		pass

func make_save(save_path):
	
	# appearance of save slot
	var dt = OS.get_datetime()
	dt['month'] = str(dt['month'])
	dt['day'] = str(dt['day'])
	dt['year'] = str(dt['year'])
	dt['hour'] = str(dt['hour'])
	dt['minute'] = str(dt['minute'])
	dt['second'] = str(dt['second'])
	load_thumbnail() # loads the latest saved thumbnail
	set_description(game.currentSaveDesc)
	set_datetime(dt['month'] + "/" + dt['day'] + "/" + dt['year'] + \
	",  " + dt['hour'] + ":" + dt['minute'] + ':' + dt['second'])
		
	# actual saving process
		
	# Actual save
	game.get_latest_nvl() # get current nvl text.
	game.get_latest_onstage() # get current on stage characters.
	var data = {'currentNodePath':game.currentNodePath, 'currentBlock': game.currentBlock,\
	'currentIndex': game.currentIndex, 'thumbnail': raw_thumbnail_data,\
	'currentSaveDesc': game.currentSaveDesc, 'history':game.history,\
	'playback': game.playback_events, 'datetime': get_datetime(), 'format':game.currentFormat,\
	'bgm_volume': vn.music_volume, 'eff_volume': vn.effect_volume, 'voice_volume': vn.voice_volume,\
	'auto_speed':vn.auto_speed, 'dvar':vn.dvar}

	var dir = Directory.new()
	if !dir.dir_exists(vn.SAVE_DIR):
		dir.make_dir_recursive(vn.SAVE_DIR)
		
	var file = File.new()
	if save_path == '':
		save_path = vn.SAVE_DIR + 'save' + str(OS.get_system_time_msecs()) + '.dat'
		self.path = save_path
	# else path is already assigned, no need to change anything
	
	var error = file.open_encrypted_with_pass(save_path, File.WRITE, "nanithefuck")
	if error == OK:
		file.store_var(data)
		file.close()
	else:
		vn.error('Error when loading saves. (Unknown reason.)')


func set_description(text):
	get_node("Button/HBoxContainer/VBoxContainer/saveInfo").bbcode_text = "[center]"+ text +"[/center]"

func set_datetime(dt):
	get_node("Button/HBoxContainer/VBoxContainer/saveTime").bbcode_text = "[center]"+ dt +"[/center]"
	
func get_datetime():
	return get_node("Button/HBoxContainer/VBoxContainer/saveTime").text

func load_thumbnail():
	var thumbnail = get_node("Button/HBoxContainer/saveThumbnail")
	var dir = Directory.new()
	if !dir.dir_exists(vn.THUMBNAIL_DIR):
		# then go by default
		thumbnail.texture = load("res://gui/default_save_thumbnail.png")
		return
	
	# so directory already exists
	dir.open(vn.THUMBNAIL_DIR)
	dir.list_dir_begin()
	
	while true:
		var file_name = dir.get_next()
		if file_name == "":
			break
		elif not file_name.begins_with("."):
			if file_name == 'thumbnail.dat':
				var file = File.new()
				var error = file.open(vn.THUMBNAIL_DIR + file_name, File.READ)
				if error == OK:
					raw_thumbnail_data = file.get_var()
					thumbnail.texture = fileRelated.data2Thumbnail(raw_thumbnail_data, game.currentFormat)
					file.close()
					break
				else: # file won't open because of some error
					thumbnail.texture = load("res://gui/default_save_thumbnail.png")
					break
			else:
				thumbnail.texture = load("res://gui/default_save_thumbnail.png")
				break
		
	dir.list_dir_end()
	return

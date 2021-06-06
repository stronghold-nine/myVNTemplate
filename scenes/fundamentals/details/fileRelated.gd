extends Node

const image_exts = ['png', 'jpg', 'jpeg']
#------------------------------------------------------------------------------
func get_save_files():
	
	var files = []
	var dir = Directory.new()
	if !dir.dir_exists(vn.SAVE_DIR):
			dir.make_dir_recursive(vn.SAVE_DIR)
	
	dir.open(vn.SAVE_DIR)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			if file.get_extension() == 'dat':
				files.append(file)
				
	dir.list_dir_end()
	return files

func data2Thumbnail(img_data:PoolByteArray, format) -> ImageTexture:
	
	var img = Image.new()
	img.create_from_data(vn.THUMBNAIL_WIDTH, vn.THUMBNAIL_HEIGHT,\
	false, format, img_data)
	var texture = ImageTexture.new()
	texture.create_from_image(img)
	
	return texture
	
func readSave(save : saveSlot) -> bool:
	var success = false
	var file = File.new()
	var error = file.open_encrypted_with_pass(save.path, File.READ, "nanithefuck")
	if error == OK:
		success = true
		var data = file.get_var()
		game.currentSaveDesc = data['currentSaveDesc']
		game.currentIndex = data['currentIndex']
		game.currentNodePath = data['currentNodePath']
		game.currentBlock = data['currentBlock']
		game.history = data['history']
		game.playback_events = data['playback']
		game.load_instruction = "load_game"
		vn.music_volume = data['bgm_volume']
		vn.effect_volume = data['eff_volume']
		vn.voice_volume = data['voice_volume']
		vn.auto_speed = data['auto_speed']
		vn.auto_bound = (7 - (vn.auto_speed + 1) * 2) * 20
		vn.dvar = data['dvar']
		file.close()
	else:
		# load save failed. The save is corrupted or removed.
		vn.error('Loading failed for unknown reasons.')
		save.queue_free()
	
	return success

#-------------------------------------------------------------------------------
func get_chara_sprites(chara_id):
	var sprites = []
	var dir = Directory.new()
	if !dir.dir_exists(vn.CHARA_DIR):
			dir.make_dir_recursive(vn.CHARA_DIR)
	
	dir.open(vn.CHARA_DIR)
	dir.list_dir_begin()
	
	while true:
		var pic = dir.get_next()
		if pic == "":
			break
		elif not pic.begins_with("."):
			var temp = pic.split(".")
			if temp[temp.size()-1] == "import":
				continue
			else:
				var pic_id = (temp[0].split("_"))[0]
				var ext = temp[1]
				if ext in image_exts and pic_id == chara_id:
					sprites.append(pic)
				
	dir.list_dir_end()
	return sprites

#-------------------------------------------------------------------------------
func path_valid(path : String) -> bool:
	var file = File.new()
	var exists = file.file_exists(path)
	file.close()
	return exists

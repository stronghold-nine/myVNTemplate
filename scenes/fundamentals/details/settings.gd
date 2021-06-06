extends Node

func _ready():
	vn.inSetting = true
	var voiceVolSlider = $voiceBox/voiceSettings/voiceSlider
	var effectVolSlider = $effectBox/effectSettings/effectVolumeSlider
	var musicVolSlider = $musicBox/musicSettings/volumeSlider
	$musicBox/musicSettings/musicVolume.text = str(vn.music_volume + 50)
	$effectBox/effectSettings/effectVolume.text = str(vn.effect_volume + 50)
	$voiceBox/voiceSettings/voiceVolume.text = str(vn.voice_volume + 50)
	musicVolSlider.value = vn.music_volume
	effectVolSlider.value = vn.effect_volume
	voiceVolSlider.value = vn.voice_volume
	if vn.music_volume <= musicVolSlider.min_value:
		AudioServer.set_bus_mute(1,true)
	else:
		AudioServer.set_bus_volume_db(1, vn.music_volume)
		
	if vn.effect_volume <= effectVolSlider.min_value:
		AudioServer.set_bus_mute(2,true)
	else:
		AudioServer.set_bus_volume_db(2, vn.effect_volume)
	
	if vn.voice_volume <= voiceVolSlider.min_value:
		AudioServer.set_bus_mute(3, true)
	else:
		AudioServer.set_bus_volume_db(2, vn.voice_volume)
	
	var auto = get_node("autoBox/autoSpeed")
	auto.add_item('Slow')
	auto.add_item('Normal')
	auto.add_item('Fast')
	auto.select(vn.auto_speed)


func _on_volumeSlider_value_changed(value):
	vn.music_volume = value
	$musicBox/musicSettings/musicVolume.text = str(value + 50)
	AudioServer.set_bus_volume_db(1, value)
	if value <= $musicBox/musicSettings/volumeSlider.min_value:
		AudioServer.set_bus_mute(1,true)
	else:
		AudioServer.set_bus_mute(1,false)


func _on_BackButton_pressed():
	vn.inSetting = false
	self.queue_free()
	

func _process(_delta):
	if Input.is_action_pressed("ui_cancel"):
		vn.inSetting = false
		self.queue_free()
		
func _on_effectVolumeSlider_value_changed(value):
	vn.effect_volume = value
	$effectBox/effectSettings/effectVolume.text = str(value + 50)
	AudioServer.set_bus_volume_db(2, value)
	if value <= $effectBox/effectSettings/effectVolumeSlider.min_value:
		AudioServer.set_bus_mute(2,true)
	else:
		AudioServer.set_bus_mute(2,false)

func _on_voiceSlider_value_changed(value):
	vn.voice_volume = value
	$voiceBox/voiceSettings/voiceVolume.text = str(value + 50)
	AudioServer.set_bus_volume_db(3, value)
	if value <= $voiceBox/voiceSettings/voiceSlider.min_value:
		AudioServer.set_bus_mute(3,true)
	else:
		AudioServer.set_bus_mute(3,false)


func _on_autoSpeed_item_selected(index):
	vn.auto_speed = index
	vn.auto_bound = ((-1)*index + 3.25)*20

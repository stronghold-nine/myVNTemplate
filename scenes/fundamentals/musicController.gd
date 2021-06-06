extends Node

onready var bgm1 = $bgm1
onready var t1 = $tween1
var in_fadeout = false

func play_bgm(path : String, vol = 0):
	in_fadeout = false
	if t1.is_active():
		t1.remove_all()
	
	bgm1.stop()
	bgm1.volume_db = vol
	bgm1.stream = load(path)
	bgm1.play()
	
func fadeout(time: float):
	if t1.is_active():
		t1.remove_all()
	if bgm1.playing:
		var vol = bgm1.volume_db
		in_fadeout = true
		t1.interpolate_property(bgm1, "volume_db", vol, -80, time, 0, Tween.EASE_IN, 0)
		t1.start()
		
func fadein(path: String, time: float, vol = 0):
	in_fadeout = false
	if t1.is_active():
		t1.remove_all()
	bgm1.stop()
	bgm1.stream = load(path)
	bgm1.play()
	t1.interpolate_property(bgm1, "volume_db", -80, vol, time, 0, Tween.EASE_IN, 0)
	t1.start()
	
func play_sound(path, vol = 0):
	$sound.volume_db = vol
	$sound.stream = load(path)
	$sound.play()
	
func play_voice(path, vol = 0):
	$voice.stop()
	$voice.volume_db = vol
	$voice.stream = load(path)
	$voice.play()
	
func stop_voice():
	$voice.stop()

func stop_bgm():
	bgm1.stop()
	
func pause_bgm():
	bgm1.set_stream_paused(true)
	
func unpause_bgm():
	bgm1.set_stream_paused(false)

func _on_tween1_tween_completed(object,_key):
	if in_fadeout:
		object.stop()
		in_fadeout = false


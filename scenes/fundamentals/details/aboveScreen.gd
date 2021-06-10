extends CanvasLayer


onready var rect = $ColorRect
onready var waveRect = $shockWave
onready var tintRect = $tintRect
onready var transition_player = $transitionPlayer
onready var tint_player = $tintPlayer

var tintOn = false


func fadeout(time):
	
	rect.visible = true
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, "ColorRect:color")
	animation.set_length(time)
	animation.track_insert_key(0, 0, Color(0,0,0,0))
	animation.track_insert_key(0, time, Color(0,0,0,1))
	transition_player.add_animation("fadeout", animation)
	transition_player.play("fadeout")
	

func fadein(time):
	
	rect.visible = true
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, "ColorRect:color")
	animation.set_length(time)
	animation.track_insert_key(0, 0, Color(0,0,0,1))
	animation.track_insert_key(0, time, Color(0,0,0,0))
	transition_player.add_animation("fadein", animation)
	transition_player.play("fadein")
	
# DO NOT USE tint AND tintREPEAT AT THE SAME TIME!
# ALWAYS REMOVE tint OR REMOVE REPEAT 

func tint(c: Color, time: float):
	
	if tintOn: # if tint is already on, overwrite old tint
		removeTint()
	
	tintRect.visible = true
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, "tintRect:color")
	animation.set_length(time)
	animation.track_insert_key(0, 0, Color(0,0,0,0))
	animation.track_insert_key(0, time, c)
	tint_player.add_animation("displaytint", animation)
	tint_player.play("displaytint")
	tintOn = true
	
	
func removeTint():
	tintOn = false
	tintRect.visible = false
	if tint_player.has_animation("displaytint"):
		tint_player.remove_animation("displaytint")
		
	if tint_player.has_animation("tintWave"):
		tint_player.remove_animation("tintWave")

	
func tintWave(c:Color,time:float):
	
	if tintOn: # overwrite old tint
		removeTint()
	
	tintRect.visible = true
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, "tintRect:color")
	animation.set_length(time)
	animation.set_loop(true)
	animation.track_insert_key(0, 0, Color(0,0,0,0))
	animation.track_insert_key(0, time/4, c)
	animation.track_insert_key(0, 3*time/4, c)
	animation.track_insert_key(0, time, Color(0,0,0,0))
	tint_player.add_animation("tintWave", animation)
	tint_player.play("tintWave")
	tintOn = true

func shockWave():
	waveRect.visible = true
	transition_player.play("shockWave")


func _on_transitionPlayer_animation_finished(anim_name):
	if anim_name == "fadein" or anim_name == "fadeout":
		rect.visible = false
		transition_player.remove_animation(anim_name)
	elif anim_name == "shockwave":
		waveRect.visible = false
	else:
		pass
		

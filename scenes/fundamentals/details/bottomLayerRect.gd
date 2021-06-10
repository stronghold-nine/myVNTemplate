extends ColorRect

onready var anim = $AnimationPlayer

func _ready():
	self.rect_position = get_viewport().size


func play_pixel():
	get_node("AnimationPlayer").play('pixel')

func pixellate(time:float):
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, ":material:shader_param/size")
	animation.set_length(time)
	animation.track_insert_key(track_index, 0, 1.0)
	animation.track_insert_key(track_index, time, 30.0)
	anim.add_animation("pixellate", animation)
	anim.play("pixellate")
	
func reverse_pixellate(time:float):
	var animation = Animation.new()
	var track_index = animation.add_track(Animation.TYPE_VALUE)
	animation.track_set_path(track_index, ":material:shader_param/size")
	animation.set_length(time)
	animation.track_insert_key(track_index, 0, 30)
	animation.track_insert_key(track_index, time, 1)
	anim.add_animation("reverse", animation)
	anim.play("reverse")
	


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"pixellate":
			print(material.get_shader_param('size'))
			anim.remove_animation(anim_name)
		
		"reverse" : self.queue_free()
		_: print("How fun")

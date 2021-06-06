extends Sprite

onready var anim_player = $AnimationPlayer

func _on_AnimationPlayer_animation_finished(_anim_name):
	self.queue_free()

extends ColorRect

func _ready():
	$AnimationPlayer.play('flash')

func _on_AnimationPlayer_animation_finished(_anim_name):
	self.queue_free()

extends CanvasLayer

func override(yes: bool):
	if yes:
		get_parent().override_save()
	
	self.queue_free()

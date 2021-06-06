extends Camera2D

onready var shakeTimer = $Timer
onready var tween = $Tween

var shake_amount = 200
var rng = RandomNumberGenerator.new()
var type = ""
const default_offset = Vector2(0,0)


func _ready():
	set_process(false)
	
func _process(delta):
	var shake_vec = Vector2()
	if type == "regular":
		shake_vec = Vector2(rng.randf_range(-shake_amount, shake_amount),\
		rng.randf_range(-shake_amount, shake_amount))
	elif type == "vpunch":
		shake_vec = Vector2(0, rng.randf_range(-shake_amount, shake_amount))
	elif type == "hpunch":
		shake_vec = Vector2(rng.randf_range(-shake_amount, shake_amount), 0)
	else:
		shake_vec = Vector2(0,0)
	
	self.offset = shake_vec * delta + default_offset
	
	
func shake(amount, time):
	
	shake_amount = amount
	if time < 0.5:
		shakeTimer.wait_time = 0.5
	else:
		shakeTimer.wait_time = time
		 
	type = "regular"	
	tween.stop_all()
	set_process(true)
	shakeTimer.start()
	

func vpunch():
		
	shake_amount = 600
	#shake_limit = 300		
	shakeTimer.wait_time = 0.9
	type = "vpunch"
	tween.stop_all()
	set_process(true)
	shakeTimer.start()
	
func hpunch():
	
		
	shake_amount = 600
	#shake_limit = 300	
	shakeTimer.wait_time = 0.9
	type = "hpunch"
	tween.stop_all()
	set_process(true)
	shakeTimer.start()
	

func _on_Timer_timeout():

	shake_amount = 200
	type = ""
	set_process(false)
	tween.interpolate_property(self, "offset", offset, default_offset, 0.1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()
	

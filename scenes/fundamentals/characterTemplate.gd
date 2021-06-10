extends Sprite
class_name character

# Optional states
var in_all = true
var apply_highlight = true
#
var timer = null
var rng = RandomNumberGenerator.new()
var counter = 0
var counter_bound = 0
var shake_amount = 0
var step_size = 0
var dir = null
var loc = Vector2()
var in_action = false
const direction = {'up': Vector2.UP, 'down': Vector2.DOWN, 'left': Vector2.LEFT, 'right': Vector2.RIGHT}
# User has to make sure the unique id for each character is UNIQUE. It is the
# user's responsibility.
# Actor properties
var display_name = null
var unique_id = null
var expression_mapping = {}
var current_expression = ""
var on_stage = false
var default_color = null
#-------------------------------------------------------------------------------
func _init(name : String, id : String, color = Color(0,0,0,1)) -> void:
	display_name = name
	unique_id = id
	default_color = color
	autofill_expression_mapping()
	chara.all_chara[unique_id] = self
	in_all = true
	apply_highlight = true

func autofill_expression_mapping():
	var related_sprites = fileRelated.get_chara_sprites(unique_id)
	for na in related_sprites:
		var temp = na.split(".")
		temp = temp[0].split("_") # throwing out the extension
		expression_mapping[temp[1]] = na
		
	#print(expression_mapping)

func change_expression(expression : String) -> bool:
	if expression == "":
		expression = 'default'
	
	if expression_mapping.has(expression):
		self.texture = load(vn.CHARA_DIR + expression_mapping[expression])
		current_expression = expression
		return true
	else:
		vn.error(expression + ' not found for character with uid ' + unique_id)
		return false
#--------------------------------------------------------------------------------
func hide():
	self.visible = false
	
func show():
	self.visible = true


func change_scale(vec2):
	self.scale = vec2

func shake(amount: float, time : float):
	if in_action:
		timer.stop()
		timer.queue_free()
		reset()

	in_action = true
	shake_amount = amount
	time = stepify(time,0.1)
	counter_bound = time/0.02
	loc = self.position
	
	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.02
	timer.connect('timeout', self, 'on_shake_timer_timeout')
	timer.start()
	
	# Another way to handle to timer is to use yield(,). But I don't
	# want to define too many signals. So it's like this currently.

	
func on_shake_timer_timeout():
	counter += 1
	if counter >= counter_bound:
		in_action = false
		timer.stop()
		timer.queue_free()
		reset()
	else:
		self.position = loc + 0.02*Vector2(rng.randf_range(-shake_amount, shake_amount),\
		rng.randf_range(-shake_amount, shake_amount))


func jump(direc : String, amount : float, time : float) -> void:
	if in_action:
		timer.stop()
		timer.queue_free()
		reset()
	
	dir = direc.to_lower()
	in_action = true
	time = stepify(time, 0.1)
	counter_bound = time/0.02
	step_size = amount/(counter_bound/2)
	loc = self.position
	
	timer = Timer.new()
	self.add_child(timer)
	timer.wait_time = 0.02
	timer.connect('timeout', self, 'on_jump_timeout')
	timer.start()
	
func on_jump_timeout():
	counter += 1
	if counter >= counter_bound:
		in_action = false
		timer.stop()
		timer.queue_free()
		reset()
	
	if counter >= counter_bound/2:
		self.position -= step_size * direction[dir]
	else:
		self.position += step_size * direction[dir]

# Reset is done this way because currently there can only be one
# animation / action at one time.
func reset():
	shake_amount = 0
	step_size = 0
	counter = 0
	counter_bound = 0
	self.position = loc

func fadein(time : float):
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "modulate", Color(0.86,0.86,0.86,0), Color(0.86,0.86,0.86,1), time,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(get_tree().create_timer(time), "timeout")
	tween.queue_free()
	
func fadeout(time : float):
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "modulate", Color(0.86,0.86,0.86,1), Color(0.86,0.86,0.86,0), time,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(get_tree().create_timer(time), "timeout")
	tween.queue_free()
	stage.remove_chara(unique_id)
	
	
func change_pos_linear(loca:Vector2, time:float):
	self.loc = loca
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(self, "position", self.position, loca, time,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(get_tree().create_timer(time), "timeout")
	tween.queue_free()


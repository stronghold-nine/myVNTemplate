extends Node2D

# this simply serves as a midpoint between calls

func helloWorld():
	print("Hello World")

func pixel_in(time):
	get_node("aboveScreen").pixellate_in(time)

func pixel_out(time):
	get_node("aboveScreen").pixellate_out(time)

func fadein(time):
	get_node("aboveScreen").fadein(time)
	
func fadeout(time):
	get_node("aboveScreen").fadeout(time)
	
func tint(c: Color,time : float):
	get_node("aboveScreen").tint(c,time)
	
func removeTint():
	get_node("aboveScreen").removeTint()
	
func tintWave(c: Color, time : float):
	get_node("aboveScreen").tintWave(c,time)
	
func shake(shake_amount, shake_timer):
	get_node("camera").shake(shake_amount,shake_timer)
	
func vpunch():
	get_node("camera").vpunch()
	
func hpunch():
	get_node("camera").hpunch()



func _ready():
	var w = get_node("aboveScreen").get_node("weather")
	for n in w.get_children():
		n.visible = false

func weather_off():
	var w = get_node("aboveScreen").get_node("weather")
	for n in w.get_children():
		n.visible = false
	
func show_weather(w_name:String):
	var w = get_node("aboveScreen").get_node("weather")
	for n in w.get_children():
		if n.name == w_name:
			n.visible = true
		else:
			n.visible = false

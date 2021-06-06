extends Node2D

# this simply serves as a midpoint between calls

func helloWorld():
	print("Hello World")
	
func fadein(time):
	get_node("colorRelated").fadein(time)
	
func fadeout(time):
	get_node("colorRelated").fadeout(time)
	
func tint(c: Color,time : float):
	get_node("colorRelated").tint(c,time)
	
func removeTint():
	get_node("colorRelated").removeTint()
	
func tintWave(c: Color, time : float):
	get_node("colorRelated").tintWave(c,time)
	
func shake(shake_amount, shake_timer):
	get_node("camera").shake(shake_amount,shake_timer)
	
func vpunch():
	get_node("camera").vpunch()
	
func hpunch():
	get_node("camera").hpunch()

func shockWave():
	get_node("colorRelated").shockWave()

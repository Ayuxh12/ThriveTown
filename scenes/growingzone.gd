extends StaticBody2D

var plant = Global.plantselected
var plantgrowing = false
var plant_grown = false

func _physics_process(delta: float) -> void:
	if not plantgrowing:
		plant = Global.plantselected

func _on_Area2D_area_entered(area: Area2D) -> void:
	if not plantgrowing:
		$plant.visible = true  # Ensure plant is visible when planted
		if plant == 1:
			plantgrowing = true
			$carrotgrowtimer.start()
			$plant.play("carrotgrowing")
		elif plant == 2:
			plantgrowing = true
			$oniongrowtimer.start()
			$plant.play("oniongrowing")
	else:
		print("Plant is already growing here.")

func _on_oniongrowtimer_timeout() -> void:
	if $plant.frame == 0:
		$plant.frame = 1
		$oniongrowtimer.start()
	elif $plant.frame == 1:
		$plant.frame = 2
		plant_grown = true

func _on_carrotgrowtimer_timeout() -> void:
	if $plant.frame == 0:
		$plant.frame = 1
		$carrotgrowtimer.start()
	elif $plant.frame == 1:
		$plant.frame = 2
		plant_grown = true

func _on_Area2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if plant_grown:
			if plant == 1:
				Global.numofcarrots += 1
				harvest_crop()
			elif plant == 2:
				Global.numofonions += 1
				harvest_crop()
		#print("Number of carrots = " + str(Global.numofcarrots))
		#print("Number of onions = " + str(Global.numofonions))

func harvest_crop() -> void:
	# Reset states and prepare field for replanting
	plantgrowing = false
	plant_grown = false
	clear_animation()

func clear_animation() -> void:
	if $plant.has_method("play"):
		$plant.stop()  # Stop the current animation
		$plant.frame = 0  # Reset the frame
		$plant.visible = false  # Hide the plant sprite to simulate an empty field

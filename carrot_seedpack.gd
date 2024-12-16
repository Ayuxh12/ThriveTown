extends StaticBody2D

var selected = false
var seed_type = 1 # carrot

var plantselected = 1 # 1=carrot, 2=onion
var numofcarrots = 0
var numofonions = 0
var numofcabbage = 0
var numofcorn = 0

func _ready() -> void:
	$AnimatedSprite2D.play("default")

func _on_Area2D_input_event(viewport, event, shape_idx):
	# Handle left-click event properly
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		Global.plantselected = seed_type
		selected = true

func _physics_process(delta):
	if selected:
		# Smoothly move to the mouse position
		global_position = global_position.move_toward(get_global_mouse_position(), 400 * delta)
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			selected = false

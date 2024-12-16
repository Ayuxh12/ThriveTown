extends CanvasLayer
class_name DayChangeUI

signal menu_done()

var current_day: int = 0  # Declare the variable

# Setter function for current_day
func set_day(new_val: int) -> void:
	current_day = new_val
	if has_node("CenterContainer/Label"):  # Ensure the node exists before accessing it
		$CenterContainer/Label.text = "Dawn of Day " + str(current_day)

# Function to start a new day
func new_day() -> void:
	current_day += 1
	if has_node("AudioStreamPlayer2D"):  # Ensure AudioStreamPlayer2D exists
		$AudioStreamPlayer2D.play(1.1)
	_change_day()

# Function to play day change animation
func _change_day() -> void:
	if has_node("AnimationPlayer"):  # Ensure AnimationPlayer exists
		$AnimationPlayer.play("change_day")

# Called when the animation finishes
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	emit_signal("menu_done")

# Ready function to automatically start a new day
func _ready() -> void:
	new_day()  # Automatically starts the day when the UI is ready

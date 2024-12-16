extends Node2D

var selected_scenario: int = 0

# References to TextureRects
@onready var high_water_image = $HighWaterImage
@onready var moderate_water_image = $ModerateWaterImage
@onready var low_water_image = $LowWaterImage

# Signal to communicate the selected scenario to the main game
signal scenario_selected(scenario: int)

func _ready() -> void:
	# Randomly select a scenario
	selected_scenario = randi() % 3 + 1  # Random number between 1 and 3
	
	# Display the corresponding image
	match selected_scenario:
		1:
			high_water_image.visible = true
		2:
			moderate_water_image.visible = true
		3:
			low_water_image.visible = true

	# Automatically proceed to the forest scene after 3 seconds
	await get_tree().create_timer(3).timeout
	emit_signal("scenario_selected", selected_scenario)
	queue_free()  # Remove this scene once the scenario is selected

extends Node2D

@onready var animplayer = $world2openingcutscene/AnimationPlayer  # AnimationPlayer for cutscene animations
@onready var cutscene_camera = $CutsceneCamera  # Reference to an independent Camera2D for the cutscene

var is_openingcutscene = false
var has_player_entered_area = false
var player = null

# Detects when the player enters the detection area
func _on_player_detection_body_entered(body: Node2D) -> void:
	if body.has_method("player"):  # Check if the node is the player
		player = body
		if not has_player_entered_area:
			has_player_entered_area = true
			_play_opening_cutscene()

# Handles the cutscene logic
func _play_opening_cutscene():
	is_openingcutscene = true
	cutscene_camera.current = true  # Activate the cutscene camera
	if player:
		player.camera.enabled = false  # Temporarily disable the player's camera
	else:
		print("Error: Player not initialized properly.")

	animplayer.play("cover_fade")  # Play the cutscene animation

	# Wait for the animation to finish, then switch back to the player's camera
	await animplayer.animation_finished
	is_openingcutscene = false
	if player:
		player.camera.enabled = true  # Re-enable the player's camera
		cutscene_camera.current = false  # Deactivate the cutscene camera

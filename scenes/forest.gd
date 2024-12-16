extends Node2D

# Preloaded scenes for dynamic instantiation
@export var rock_scene: PackedScene = preload("res://scenes/rock/rock.tscn")
@export var tree_scene: PackedScene = preload("res://scenes/tree/tree.tscn")
@export var fish_scene: PackedScene = preload("res://scenes/fishing/fishing_spot.tscn")

# Exposed Player and UI instances
@export var player: Player  # Instance of Player.gd
@export var day_change_ui: DayChangeUI  # Instance of DayChangeUI.gd

# Ending scene reference
@export var end_scene: PackedScene = preload("res://scenes/Ending/ending_scene.tscn")
@export var water_animation : PackedScene  # Reference to the animation scene (drag and drop the .tscn file in the Inspector)

# UI References
@onready var tired_label = $CanvasLayer/TiredLabel
@onready var fade_to_black = $FadeToBlack
@onready var intro_textbox = $"CanvasLayer2/Intro Textbox"
@onready var music = $Music
@onready var tile_map = $TileMap
var dialogue:Array[String] = ["script name - textbox.gd"]
# Plant growth logic
var plantselected = 1  # 1 = carrot, 2 = onion
var numofcarrots = 0
var numofonions = 0

# --- Game logic functions ---
func _ready() -> void:
	# Play initial animations
	$Smoke/AnimationPlayer.play("Smoke")

	# Connect UI and game signals
	$CanvasLayer/MoneyUI.end_game.connect(end_game)
	
	# Ensure player and health component are valid
	if player and player.has_node("health_component"):
		player.health_component.death.connect(show_tired)
	else:
		print("Error: Player or HealthComponent is missing!")

	# Spawn initial game objects
	spawn_objects($RockSpawners, rock_scene)
	spawn_objects($TreeSpawners, tree_scene)
	spawn_objects($FishingSpawner, fish_scene)

	# Ensure day_change_ui is correctly initialized
	if not day_change_ui:
		print("Error: DayChangeUI instance is missing!")
		return

func spawn_objects(spawner_parent: Node, scene: PackedScene) -> void:
	# Dynamically instantiate objects at spawner locations
	for spawner in spawner_parent.get_children():
		var instance = scene.instantiate()
		instance.global_position = spawner.global_position
		tile_map.add_child(instance)

func end_game() -> void:
	fade_to_black.play("fade")
	await fade_to_black.animation_finished
	get_tree().change_scene_to_packed(end_scene)

func show_tired() -> void:
	tired_label.show()

func start_music() -> void:
	music.play()

# --- Tavern and Transition Logic ---
func go_to_tavern() -> void:
	fade_to_black.play("fade")
	await fade_to_black.animation_finished
	player.global_position = $Tavern/TavernSpawnPoint.global_position
	fade_to_black.play("fade_back")

func _on_player_detector_body_entered(body: Player) -> void:
	body.input_component.interact.connect(go_to_tavern)
	$AnimationPlayer3.play("click")
	$AnimatedSprite2D3.show()
	player = body

func _on_player_detector_body_exited(body: Player) -> void:
	body.input_component.interact.disconnect(go_to_tavern)
	$AnimatedSprite2D3.hide()

func _on_tavern_leave_body_entered(body: Node2D) -> void:
	fade_to_black.play("fade")
	await fade_to_black.animation_finished
	body.global_position = $TavernHouseSpawn.global_position
	fade_to_black.play("fade_back")

# --- Respawn Objects and Bed Use ---
func _respawn_objects() -> void:
	# Clear existing objects
	for child in tile_map.get_children():
		if child is TreeObject or child is RockObject or child is FishingObject or child is Item:
			child.queue_free()

	# Respawn objects
	spawn_objects($RockSpawners, rock_scene)
	spawn_objects($TreeSpawners, tree_scene)
	spawn_objects($FishingSpawner, fish_scene)

func _on_bed_bed_used() -> void:
	music.stream_paused = true
	if player and player.health_component:
		player.health_component.damage(-player.health_component.max_hp)
	$Tavern.remove_customers()

	# Day change logic
	if day_change_ui:
		if day_change_ui.has_method("new_day"):
			day_change_ui.new_day()  # Call to start the new day and play animation
		else:
			print("Error: day_change_ui or new_day method is missing!")
	else:
		print("Error: day_change_ui is null!")

	_respawn_objects()
	$CanvasLayer/CollectList.remove_all()
	if day_change_ui:
		var animation_player = day_change_ui.get_node("AnimationPlayer")
		if animation_player:
			await animation_player.animation_finished
		else:
			print("Error: AnimationPlayer node is missing in DayChangeUI!")

	music.stream_paused = false

# --- Day Change Logic ---
func _on_day_change_ui_menu_done() -> void:
	if day_change_ui and day_change_ui.has_method("current_day"):
		if day_change_ui.current_day == 1:
			# Setup dialogue
			var dialogue: Array[String] = [
				"Welcome to the game!",
				"Your goal is to manage resources wisely.",
				"Good luck, and have fun!"
			]
			# Display dialogue
			intro_textbox.show()
			intro_textbox.set_dialogue(dialogue)
	else:
		print("Error: day_change_ui or current_day property is missing!")

	tired_label.hide()
	if player:
		player.stop_activities = false
	start_music()

func _on_intro_textbox_text_finished() -> void:
	intro_textbox.hide()
	
func _physics_process(delta: float) -> void:
	$carrottext.text = ("= " + str(Global.numofcarrots))
	$oniontext.text = ("= " +str(Global.numofonions))
	$oniontext.text = ("= " +str(Global.numofcabbages))
	$oniontext.text = ("= " +str(Global.numofcorns))




# Load the water animation scene

func initialize_water_animation():
	var water_animation_instance = water_animation.instantiate()
	add_child(water_animation_instance)  # Add it as a child of the current scene
	
	# Position the animation (adjust based on your scene layout)
	#water_animation_instance.position = Vector2(400, 300)  # Example coordinates

func initialize_sprinkler_animation():
	var sprinkler_animation_instance = initialize_sprinkler_animation().instantiate()
	add_child(sprinkler_animation_instance)

func initialize_smoke_animation():
	var smoke_animation_instance = initialize_smoke_animation().instentiate()
	add_child(smoke_animation_instance)

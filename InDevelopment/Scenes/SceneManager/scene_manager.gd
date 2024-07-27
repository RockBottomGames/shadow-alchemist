extends Node
class_name SceneManager

@onready var MAIN_MENU = preload("res://InDevelopment/Scenes/MainMenu/MainMenu.tscn")
@onready var FIRST_LEVEL = preload("res://InDevelopment/Testing/TestingArea.tscn")

@onready var menu_layer: CanvasLayer = $MenuLayer
@onready var game_layer: Node2D = $GameLayer

var current_game_in_layer: Node = null
var current_menu_in_layer: Node = null

var _is_reset = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.scene_manager = self
	bring_up_main_menu()

func _new_main_menu() -> void:
	current_menu_in_layer = MAIN_MENU.instantiate()
	menu_layer.add_child(current_menu_in_layer)

func pause_game():
	get_tree().paused = true

func play_game():
	get_tree().paused = false

func on_level_exited():
	if current_game_in_layer != null:
		current_game_in_layer.tree_exited.disconnect(on_level_exited)
		current_game_in_layer = null
	if _is_reset:
		_is_reset = false
		start_first_level()
		


func bring_up_main_menu() -> void:
	if current_menu_in_layer != null:
		if current_menu_in_layer.is_class("MainMenu"):
			current_menu_in_layer.reopen()
		else:
			current_menu_in_layer.queue_free()
			_new_main_menu()
	else:
		_new_main_menu()
	pause_game()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("main_menu"):
		if current_menu_in_layer != null:
			if current_menu_in_layer.visible:
				current_menu_in_layer.close()
				play_game()
			else:
				current_menu_in_layer.open()
				pause_game()
		else:
			bring_up_main_menu()
	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func resume() -> void:
	if current_menu_in_layer != null:
		current_menu_in_layer.close()
	play_game()
	

func start_first_level() -> void:
	if current_menu_in_layer != null:
		current_menu_in_layer.close()
	if current_game_in_layer != null:
		_is_reset = true
		current_game_in_layer.queue_free()
		return
	current_game_in_layer = FIRST_LEVEL.instantiate()
	current_game_in_layer.tree_exited.connect(on_level_exited)
	game_layer.add_child(current_game_in_layer)
	play_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _exit_tree() -> void:
	Globals.scene_manager = null
 

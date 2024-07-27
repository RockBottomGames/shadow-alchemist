extends MarginContainer
class_name MainMenu

@onready var continue_button_container: MarginContainer = $VBoxContainer/VBoxContainer/ContinueButtonContainer

func _update_continue_button_visibility() -> void:
	if Globals.scene_manager != null and Globals.scene_manager.current_game_in_layer != null:
		continue_button_container.show()
	else:
		continue_button_container.hide()
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_continue_button_visibility()

func close() -> void:
	hide()

func open() -> void:
	_update_continue_button_visibility()
	show()

func toggle() -> void:
	if visible:
		close()
	else:
		open()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	Globals.scene_manager.start_first_level()


func _on_continue_button_pressed() -> void:
	Globals.scene_manager.resume()


func _on_quit_button_pressed() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	get_tree().quit()

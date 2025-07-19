extends Control



func _on_retry_button_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")


func _on_exit_button_pressed() -> void:
    get_tree().quit(0)

func player_found():
    self.visible = true
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

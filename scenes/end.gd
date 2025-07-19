extends Control



func _on_retry_button_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")


func _on_exit_button_pressed() -> void:
    get_tree().quit(0)

func game_end():
    self.visible = true
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

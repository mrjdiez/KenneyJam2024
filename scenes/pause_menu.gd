extends Control

func _physics_process(delta: float) -> void:
    if Input.is_action_just_pressed("pause"):
        if not self.visible:
            self.visible = true
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
        else:
            self._on_close_button_pressed()

func _on_close_button_pressed() -> void:
    self.visible = false
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_main_menu_pressed() -> void:
    get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_exit_pressed() -> void:
    get_tree().quit(0)

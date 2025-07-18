extends Node3D

@onready var raycasts: Node3D = %Rays
@onready var light: SpotLight3D = %SpotLight3D
@export var default_color: Color = Color.WHITE
@export_enum("side", "up_down") var animation: String = "up_down"

func _ready() -> void:
    $AnimationPlayer.play(self.animation)

func _physics_process(delta: float) -> void:
    for raycast: RayCast3D in self.raycasts.get_children():
        if raycast.is_colliding():
            self.light.light_color = Color.RED
            $WarningDownTimer.start(0)
            var player: Node3D = raycast.get_collider()
            var position = player.global_position
            get_tree().call_group("player_watcher", "player_found", position)

func _on_warning_down_timer_timeout() -> void:
    self.light.light_color = self.default_color

func power_down():
    $AnimationPlayer.play("RESET")
    self.light.light_energy = 0
    for raycast: RayCast3D in self.raycasts.get_children():
        raycast.enabled = false

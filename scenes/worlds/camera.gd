extends Node3D

@onready var raycasts: Node3D = %Rays
@onready var light: SpotLight3D = %SpotLight3D
@export var default_color: Color = Color.WHITE
@export_enum("side", "up_down") var animation: String = "up_down"
var paused = false

func _ready() -> void:
    $AnimationPlayer.play(self.animation)
    $%SpotLight3D.light_color = self.default_color

func _physics_process(delta: float) -> void:
    if not self.paused:
        for raycast: RayCast3D in self.raycasts.get_children():
            if raycast.is_colliding():
                self.light.light_color = Color.RED
                $WarningDownTimer.start(0)
                var player: Node3D = raycast.get_collider()
                var position = player.global_position
                get_tree().call_group("game_state_watcher", "player_found")

func _on_warning_down_timer_timeout() -> void:
    self.light.light_color = self.default_color

func player_found():
    self.pause()

func power_down():
    $AnimationPlayer.play("RESET")
    self.light.light_energy = 0
    for raycast: RayCast3D in self.raycasts.get_children():
        raycast.enabled = false

func pause():
    self.paused = true
    $AnimationPlayer.pause()

func unpause():
    self.paused = false
    $AnimationPlayer.play()

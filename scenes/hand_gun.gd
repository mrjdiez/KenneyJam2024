class_name Gun extends Node3D

@export_category("Gun configuration")

@export var max_ammo: int = 30
@export var gun_cooldown: float = 1.0
@export var automatic: bool = false

@export_category("Node Configuration")
@export var parent: Player
@export var bullet_origin: Marker3D
@export var cooldown_timer: Timer

@onready var current_ammo: int = max_ammo


func _ready() -> void:
    self._update_ui()
    self.cooldown_timer.wait_time = self.gun_cooldown
    self.cooldown_timer.timeout.connect(self._on_gun_cooldown_timeout)

func shoot(shoot_target: Vector3):  
    if self.current_ammo and self.cooldown_timer.is_stopped():
        var bullet = Bullet.create(%BulletOrigin.global_position, shoot_target)
        %Bullets.add_child(bullet)
        bullet.fire()
        self.current_ammo -= 1
        self._update_ui()
        self.cooldown_timer.start()

func _update_ui():
    get_tree().call_group("UI", "update_current_ammo", self.current_ammo)

func _on_gun_cooldown_timeout() -> void:
    if Input.is_action_pressed("shoot") and self.automatic:
        self.shoot(self.parent.get_shoot_target())

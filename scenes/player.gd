class_name Player extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 5
@export var jump_speed: int = 5
@export var projectiles_parent: Node3D
var mouse_sensitivity = 0.002
var can_interact = false
var paused := false

@onready var animation_player = %AnimationPlayer
@onready var camera: Camera3D = %Camera3D
@onready var crosshair: TextureRect = %CrossHair
@onready var interact_crosshair: TextureRect = %InteractCrosshair
@onready var gun: Gun = %HandGun
@onready var raycast: RayCast3D = %RayCast3D

func _ready() -> void:
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    self.interact_crosshair.visible = false

func _input(event):
    if not self.paused:
        if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
            rotate_y(-event.relative.x * mouse_sensitivity)
            $Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
            $Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
        if Input.is_action_just_pressed("exit"):
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
        if Input.is_action_just_pressed("shoot"):
            self._shoot()
        if self.can_interact and Input.is_action_just_pressed("interact"):
            self._interact()
        
func _physics_process(delta):
    if not self.paused:
        velocity.y += -gravity * delta
        var input = Input.get_vector("left", "right", "forward", "back")
        var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
        if movement_dir.length() != 0:
            self.animation_player.play("walk")
        else:
            self.animation_player.play("idle")
        velocity.x = movement_dir.x * speed
        velocity.z = movement_dir.z * speed
        
        move_and_slide()
        if is_on_floor() and Input.is_action_just_pressed("jump"):
            velocity.y = jump_speed
            
        if self.raycast.is_colliding() and not self.can_interact:
            self.crosshair.visible = false
            self.interact_crosshair.visible = true
            self.can_interact = true
        elif not self.raycast.is_colliding() and self.can_interact:
            self.crosshair.visible = true
            self.interact_crosshair.visible = false
            self.can_interact = false

func _interact() -> void:
    var target = self.raycast.get_collider()
    target.interact()
    print(target)

func _shoot():
    self.gun.shoot(self.get_shoot_target())

func get_shoot_target() -> Vector3:
    var ch_pos = self.crosshair.position + self.crosshair.size * 0.5
    var ray_from = self.camera.project_ray_origin(ch_pos)
    var ray_dir = self.camera.project_ray_normal(ch_pos)
    
    var col = get_parent().get_world_3d().direct_space_state.intersect_ray(PhysicsRayQueryParameters3D.create(ray_from, ray_from + ray_dir * 1000, 0b11, [self]))
    var shoot_target: Vector3
    if col.is_empty():
        shoot_target = ray_from + ray_dir * 1000
    else:
        shoot_target = col.position
    return shoot_target

func pause():
    if self.can_interact:
        self.interact_crosshair.visible = false
    else:
        self.crosshair.visible = false
    self.paused = true
        

func unpause():
    if self.can_interact:
        self.interact_crosshair.visible = true
    else:
        self.crosshair.visible = true
    self.paused = false
    
func player_found():
    self.pause()
    
func game_end():
    self.pause()

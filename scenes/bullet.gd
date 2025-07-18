class_name Bullet extends CharacterBody3D

static var scene: PackedScene = preload("uid://dvkso3wnttibp")
const SPEED: int = 20
const TTL: int = 3
var direction: Vector3
var spawn: Vector3
var fired := false

static func create(spawn_point: Vector3, _direction: Vector3) -> Bullet:
    var instance: Bullet = scene.instantiate()
    instance.direction = _direction
    instance.spawn = spawn_point
    return instance

func fire() -> void:
    self.fired = true
    self.global_position = self.spawn
    self.look_at(self.direction)
    %Timer.wait_time = self.TTL
    %Timer.start()

func _physics_process(delta: float) -> void:
    if self.fired:
        var col = self.move_and_collide(-delta * self.SPEED * transform.basis.z)
        if col:
            var collider = col.get_collider(0)
            if collider.has_method("hit"):
                collider.hit()
            self.queue_free.call_deferred()

func _on_timer_timeout() -> void:
    self.queue_free.call_deferred()

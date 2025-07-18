extends StaticBody3D

@export var objects: Array[Node3D]

func interact() -> void:
    self.collision_layer = 1
    for target in objects:
        target.power_down()

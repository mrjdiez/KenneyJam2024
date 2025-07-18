extends StaticBody3D

func interact():
    $AnimationPlayer.play("move")
    self.collision_layer = 1

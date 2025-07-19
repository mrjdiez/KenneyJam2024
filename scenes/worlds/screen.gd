extends StaticBody3D

func interact():
    print("Objetivo alcanzado.")
    get_tree().call_group("game_state_watcher", "game_end")

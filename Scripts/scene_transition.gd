extends CanvasLayer

@onready var anim: AnimationPlayer = $Control/AnimationPlayer

func change_scene_to(new_scene : String):
	anim.play("go")
	await(anim.animation_finished)
	get_tree().change_scene_to_file(new_scene)
	anim.play_backwards("go")

func restart_current_scene():
	anim.play("go")
	await(anim.animation_finished)
	get_tree().reload_current_scene()
	anim.play_backwards("go")

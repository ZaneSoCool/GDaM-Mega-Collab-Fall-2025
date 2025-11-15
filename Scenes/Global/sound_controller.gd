extends Node

#made by Zane Pederson

@onready var music: AudioStreamPlayer = $Music
@onready var button_press: AudioStreamPlayer = $ButtonPress

func changeSong(newSong : AudioStream):
	if !music.playing:
		music.stream = newSong
		music.play()
	else:
		fadeMusic(-80, 1)
		await(get_tree().create_timer(1).timeout)
		music.stream = newSong
		fadeMusic(0, 1)
	
func buttonPressed():
	button_press.play()

func fadeMusic(volume : float, duration : float):
	var tween = get_tree().create_tween()
	tween.tween_property(music, "volume_db", volume, duration)

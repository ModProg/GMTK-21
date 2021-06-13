class_name Music

const music = [preload("res://Sound/Music/4.wav"), preload("res://Sound/Music/7.wav"), preload("res://Sound/Music/6.wav")]

static func get_music_by_id(id: int) -> AudioStreamMP3:
	return music[id - 1]

static func get_music_by_name(name: String) -> AudioStreamMP3:
	return load("res://Sound/Music/" + name + ".mp3") as AudioStreamMP3

static func get_random_music() -> AudioStreamMP3:
	return music[randi() % music.size()]

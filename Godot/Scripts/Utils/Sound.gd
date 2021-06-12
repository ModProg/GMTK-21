class_name Music

const music = [preload("res://Sound/Music/01_62s.mp3"), preload("res://Sound/Music/02_19s.mp3")]

static func get_music_by_id(id: int) -> AudioStreamMP3:
	return music[id - 1]

static func get_music_by_name(name: String) -> AudioStreamMP3:
	return load("res://Sound/Music/" + name + ".mp3") as AudioStreamMP3

class_name Text

const icons = {
	"Air": preload("res://Art/Icons/Air Icon.tres"),
	"Earth": preload("res://Art/Icons/Earth Icon.tres"),
	"Fire": preload("res://Art/Icons/Fire Icon.tres"),
	"Water": preload("res://Art/Icons/Water Icon.tres")
}

static func iconize(label: RichTextLabel, text: String):
	var last_end = 0
	label.text = ""
	var font = label.get_font("normal_font")
	var height = font.get_ascent()-font.get_descent()
	var rg = RegEx.new()
	rg.compile("{{(.*?)}}")
	for result in rg.search_all(text):
		label.add_text(text.substr(last_end,result.get_start()-last_end))
		label.add_image(icons[result.get_string(1)],0,height)
		last_end = result.get_end()
	label.add_text(text.substr(last_end, text.length()-last_end))

extends Control


signal change_cell_size(cell_size)

func _enter_cell_size():
	emit_signal("change_cell_size", int($bg/cell_size_e.get_text()))


signal change_l_color(l_color)

func _from_string_to_color(string):
	var color = string.split_floats(", ")
	var r = color[0] / 255
	var g = color[1] / 255
	var b = color[2] / 255
	return Color(r, g, b)

func _enter_l_color():
	emit_signal("change_l_color", _from_string_to_color($bg/l_color_e.get_text()))


signal change_l_width(l_width)

func _enter_l_width():
	emit_signal("change_l_width", float($bg/l_width_e.get_text()))


func _redraw_bg():
	$bg.set_size(Vector2($bg.get_size().x, get_viewport_rect().size.y))


func _ready():
	get_tree().get_root().connect("size_changed", self, "_redraw_bg")

	$bg.set_as_toplevel(true)

	$bg/cell_size_b.connect("button_down", self, "_enter_cell_size")
	connect("change_cell_size", get_node("/root/main"), "_change_cell_size")
	$bg/cell_size_b.emit_signal("button_down")

	$bg/l_color_b.connect("button_down", self, "_enter_l_color")
	connect("change_l_color", get_node("/root/main"), "_change_l_color")
	$bg/l_color_b.emit_signal("button_down")

	$bg/l_width_b.connect("button_down", self, "_enter_l_width")
	connect("change_l_width", get_node("/root/main"), "_change_l_width")
	$bg/l_width_b.emit_signal("button_down")

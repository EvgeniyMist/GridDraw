extends Polygon2D


const bg_color = Color.white
const l_color = Color.gray
const l_width = 1


func draw_grid(x_left, y_top, x_right, y_bottom, cell_size):
	# draw background
	set_polygon([Vector2(x_left, y_top), Vector2(x_right, y_top),
				 Vector2(x_right, y_bottom), Vector2(x_left, y_bottom)])
	# draw horisontal lines
	for i in range(y_top, y_bottom + cell_size, cell_size):
		var line = load("res://src/line.gd").new()
		line.set_main_prop(l_color, l_width)
		line.set_points([Vector2(x_left, i), Vector2(x_right, i)])
		add_child(line)
	# draw vertical lines
	for j in range(x_left, x_right + cell_size, cell_size):
		var line = load("res://src/line.gd").new()
		line.set_main_prop(l_color, l_width)
		line.set_points([Vector2(j, y_top), Vector2(j, y_bottom)])
		add_child(line)


func redraw_grid(x_left, y_top, x_right, y_bottom, cell_size):
	for line in get_children():
		line.free()
	draw_grid(x_left, y_top, x_right, y_bottom, cell_size)


func _ready():
	set_color(bg_color)

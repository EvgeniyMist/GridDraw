extends Node2D


# variables, whose values are set in the menu
var cell_size
var l_color
var l_width

var min_dist = 10
var drawing = false


func _calcul_distance(x1, y1, x2, y2):
	return sqrt(pow((x1 - x2), 2) + pow((y1 - y2), 2))


func _change_cell_size(new_cell_size):
	_redraw_grid(new_cell_size)
	# redraw lines
	var lines_group = get_tree().get_nodes_in_group("lines")
	var menu_vec = Vector2($menu.get_rect().size.x, 0)
	for line in lines_group:
		var points = line.get_points()
		for i in range(len(points)):
			points[i] = ((points[i] - menu_vec) * new_cell_size / cell_size +
						 menu_vec)
		line.set_points(points)
	# change cell size
	cell_size = new_cell_size


func _change_l_color(new_l_color):
	l_color = new_l_color


func _change_l_width(new_l_width):
	l_width = new_l_width


func _is_event_in_grid(event):
	var menu_rect = $menu.get_rect()
	return (event.position.x > menu_rect.size.x + menu_rect.position.x and
			event.position.y > menu_rect.position.y)


func _redraw_grid(new_cell_size=cell_size):
	$grid.redraw_grid($menu.get_rect().size.x + $menu.get_rect().position.x,
					  $menu.get_rect().position.y,
					  get_viewport_rect().size.x,
					  get_viewport_rect().size.y,
					  new_cell_size)


func _input(event):
	var lines_group = get_tree().get_nodes_in_group("lines")
	if event is InputEventMouseButton and _is_event_in_grid(event):
		if event.button_index == BUTTON_LEFT and event.pressed:
			# contact the nearest node
			var x_node = round(event.position.x / cell_size) * cell_size
			var y_node = round(event.position.y / cell_size) * cell_size
			if min_dist < _calcul_distance(x_node, y_node, event.position.x,
										   event.position.y):
				return
			var node = Vector2(x_node, y_node)
			if not drawing:
				# create new line
				drawing = true
				var line = load("res://src/line.gd").new()
				line.set_main_prop(l_color, l_width)
				add_child(line)
				line.add_to_group("lines")
				lines_group = get_tree().get_nodes_in_group("lines")
			# add new node to the line
			lines_group.back().change_last_point(node)
			lines_group.back().add_point(node)
		elif event.button_index == BUTTON_RIGHT and event.pressed and drawing:
			# finish drawing of the line
			lines_group.back().remove_last_point()
			drawing = false
	elif event is InputEventMouseMotion and drawing:
		if _is_event_in_grid(event):
			# draw line to current cursor position
			lines_group.back().change_last_point(Vector2(event.position.x,
														 event.position.y))
		else:
			# break the line at the last node
			var last_node = lines_group.back().get_points()[-2]
			lines_group.back().change_last_point(last_node)
	elif event is InputEventKey and event.pressed:
		var str_scancode = OS.get_scancode_string(event.scancode)
		var change = Vector2(0, 0)
		# determine in which way "step" was made
		if str_scancode == "Right":
			change.x = -cell_size
		elif str_scancode == "Left":
			change.x = cell_size
		elif str_scancode == "Down":
			change.y = -cell_size
		elif str_scancode == "Up":
			change.y = cell_size
		else:
			return
		# redraw lines
		for line in lines_group:
			var points = line.get_points()
			for i in range(len(points)):
				points[i] += change
			line.set_points(points)


func _ready():
	get_tree().get_root().connect("size_changed", self, "_redraw_grid")
	pass


func _process(delta):
	pass

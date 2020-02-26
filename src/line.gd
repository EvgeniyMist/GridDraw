extends Line2D


func change_last_point(point):
	if get_point_count() != 0:
		remove_point(get_point_count() - 1)
	add_point(point)


func get_last_point():
	if get_point_count() != 0:
		return get_points()[get_point_count() - 1]


func remove_last_point():
	if get_point_count() != 0:
		remove_point(get_point_count() - 1)


func set_main_prop(color, width):
	set_default_color(color)
	set_width(width)

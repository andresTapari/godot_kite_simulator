extends Area2D

signal clicked

export var target_path: NodePath

var target: Area2D
var enable: bool = false
var label_tag: Label

func _ready() -> void:
	$gimbal.visible = false
	label_tag = get_node("Label")

func _process(delta) -> void:
	$gimbal.look_at(target.position)

func relocate() -> void:
	var x: float
	var y: float
	var screen_limits:Vector2 = get_node("/root").size
	var random = RandomNumberGenerator.new()
	random.randomize()
	var offset: Vector2 =  Vector2(($Sprite.texture.get_size().x * scale.x), \
								($Sprite.texture.get_size().y * scale.y))
	x = rand_range(0 + offset.x/2, screen_limits.x  - offset.x/2)
	y = rand_range(0 + offset.y/2, screen_limits.y  - offset.x/2)  
	var new_position: Vector2 = Vector2(x,y)
	var target_list = get_parent().target_list
	if target_list.size() > 1:
		for element  in get_parent().target_list:
			if new_position.distance_to(element.position) < offset.x:
				relocate()
				return
	position = Vector2(x,y)
	
	
func set_enable(value: bool) -> void:
	enable = value

func set_color(value: Color) -> void:
	$Sprite.modulate = value
	$gimbal/Cursor.modulate = value

func gimbal_visible(value: bool) -> void:
	if target == self:
		$gimbal.visible = false
	else:
		$gimbal.visible = value

func update_cursor_direction() -> void:
	$gimbal.look_at(target.position)

func _on_green_hit_box_mouse_entered():
	pass # Replace with function body.

func _on_hit_box_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed) and enable:
		for element  in get_parent().target_list:
			element.gimbal_visible(false)
		self.set_enable(false)
		self.gimbal_visible(true)
		target.relocate()
		target.set_enable(true)
		emit_signal("clicked")

func _on_hit_box_area_entered(area):
	relocate()

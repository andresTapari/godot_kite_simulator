extends MarginContainer

signal send_scale(value)
signal send_n_target(value)
signal send_timer(value)

onready var label_scale_percent = get_node("MENU/HBoxContainer/Label2")
onready var label_target_number = get_node("MENU/HBoxContainer2/Label2")
onready var label_timer  = get_node("MENU/HBoxContainer3/Label2")
func _ready():
	pass # Replace with function body.


func _on_HSlider_value_changed(value):
	label_scale_percent.text = String(value) + "%"
	emit_signal("send_scale",value/100)


func _on_HSlider2_value_changed(value):
	label_target_number.text = String(value)
	emit_signal("send_n_target",value)



func _on_HSlider3_value_changed(value: float) -> void:
	label_timer.text = String(int(value))
	emit_signal("send_timer",value)

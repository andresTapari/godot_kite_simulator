extends Node2D

var TARGET = preload("res://scenes/template_hit_box.tscn")

onready var menu = get_node("CanvasLayer/Menu")
onready var timer_label  = get_node("CanvasLayer/timer_n_score/VBoxContainer/CLOCK") 
onready var score_label  = get_node("CanvasLayer/timer_n_score/VBoxContainer/SCORE")
onready var score_dialog_score  = get_node("CanvasLayer/SCORE_DIALOG/HBoxContainer/Puntaje")
onready var score_dialog_aim    = get_node("CanvasLayer/SCORE_DIALOG/HBoxContainer2/Exactitud")
onready var score_dialog_target = get_node("CanvasLayer/SCORE_DIALOG/HBoxContainer3/blancos")
onready var score_dialog_size = get_node("CanvasLayer/SCORE_DIALOG/HBoxContainer4/escala")
onready var score_dialog_clicks = get_node("CanvasLayer/SCORE_DIALOG/HBoxContainer5/Clicks")
var clock_s : float = 10
var clock_ms: float = 00
var score: int = 0
var _scale: float = 0
var n_target: int = 0
var clicks: int = 0
var game_started: bool = false

var color_list: Array = [	Color.green,
							Color.royalblue,
							Color.aquamarine,
							Color.blue,
							Color.blueviolet,
							Color.red,
							Color.orangered,
							Color.orchid,
							Color.sandybrown,
							Color.yellow,
							Color.yellowgreen]

var target_list: Array = []

func _ready():
	menu.connect("send_n_target",self,"handle_recive_n_target")
	menu.connect("send_scale",self,"handle_recive_percent")
	menu.connect("send_timer",self,"hanfle_recive_timer")
	spawn_targets(1)
	n_target = 1
	_scale = 0.5

func _input(event):
	if Input.is_action_just_pressed("ui_click"):
		clicks += 1
		print(clicks)
func spawn_targets(_value: int) -> void:

	# Limpiamos la lista y eliminamos nodos anteriores
	if !target_list.empty():
		for element in target_list:
			element.queue_free()
		target_list.clear()
	# Spawn de targets:
	for element in range(_value):
		var new_target = TARGET.instance()
		add_child(new_target)
		new_target.relocate()
		new_target.label_tag. text = String(element)
		new_target.connect("clicked",self,"handle_clicked_target")
		target_list.append(new_target)

	# Establecemos objetivos
	print("Lista:" + String(target_list.size()))
	if target_list.size() > 1:
		for n in range(target_list.size()):
			if n < target_list.size():
				target_list[n-1].target = target_list[n] 
			else:
				target_list[n-1].target = target_list[0]
	else:
		target_list[0].target = target_list[0]

	# Colorear
	for element in target_list:
		randomize()
		element.set_color(color_list[randi() % color_list.size()])
	
	target_list[0].enable = true

func handle_clicked_target()->void:
	if game_started == false:
		clicks = 1
		$Timer.start()
		game_started = true
	if menu.visible:
		menu.hide()
	score += 1
	score_label.text = String(score)

func handle_recive_n_target(value: int) -> void:
	n_target = value
	spawn_targets(value)


func handle_recive_percent(value: float) -> void:
	_scale = value
	for element in target_list:
		element.scale = Vector2(value,value)
	pass

func hanfle_recive_timer(value: float) -> void:
	clock_s = value
	timer_label.text = String(clock_s) + ":" +String(clock_ms)
	pass


func _on_Timer_timeout():
	clock_ms -=5
	if clock_ms <= 0:
		clock_s -= 1
		clock_ms = 99
		if clock_s == 0:
#			get_tree().paused = true
			for element in target_list:
				element.hide()
			$CanvasLayer/timer_n_score.hide()
			score_dialog_score.text = String(score)
			score_dialog_clicks.text = String(clicks)
			score_dialog_aim.text = String(stepify(float(score) / float(clicks) * 100, 0.01)) + "%"
			score_dialog_target.text = String(n_target)
			score_dialog_size.text = String(_scale * 100) + "%"
			$CanvasLayer/SCORE_DIALOG.show()
	timer_label.text = String(clock_s) + ":" +String(clock_ms)

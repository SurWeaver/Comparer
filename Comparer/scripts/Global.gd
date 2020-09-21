extends Node

var first : Card = null
var second : Card = null

var rng = RandomNumberGenerator.new()
var game_node

func _ready():
	rng.randomize()

func _input(event): # Управление
	if Input.is_action_just_pressed("Restart"):
		reset_cards()
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed("Exit"):
		get_tree().quit()

func can_open():
	return first == null || second == null

func reset_cards():
	first = null
	second = null

func add_card(card : Card):
	if first == null:
		first = card
	elif second == null:
		second = card

func check_cards():
	if first && second:
		if first.index == second.index:
			destroy_cards()
			game_node.add_pairs()
		else:
			hide_cards()
			game_node.add_mistakes()
		reset_cards()
		game_node.check_cards()

func hide_cards():
	first.hide()
	second.hide()

func destroy_cards():
	first.destroy()
	second.destroy()

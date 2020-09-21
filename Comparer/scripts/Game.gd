class_name Game
extends Control

onready var grid_node = $VBoxContainer/Grid
onready var win_label = $VBoxContainer/CenterContainer/WinLabel
onready var mistake_label = $VBoxContainer/MarginContainer/HBoxContainer/MistakeLabel
onready var pairs_label = $VBoxContainer/MarginContainer/HBoxContainer/PairsLabel

onready var start_pos = grid_node.rect_global_position
onready var box_size = grid_node.rect_size

var card = preload("res://scenes/Card.tscn")
var grid_size = Vector2(6, 3) # Размер поля игры

var grid = [] # Хранятся карты-узлы

var mistakes = 0
var pairs = 0


func _ready():
	Global.game_node = self
	set_grid()
	randomize_grid()

# Инициализация поля, если 
func set_grid():
	if grid_node.get_child_count() == 0:
		for x in range(grid_size.x):
			grid.append([])
			for y in range(grid_size.y):
				grid[x].append(0)
				grid[x][y] = card.instance()
				grid[x][y].position = Vector2((x+1) / (grid_size.x+1) * box_size.x, (y+1) / (grid_size.y+1) * box_size.y)
				grid_node.add_child(grid[x][y])

func randomize_grid():
	var card_count = grid_size.x * grid_size.y
	var pairs = int(card_count / 2)
	for i in range(pairs): # Для каждой пары карт подбираем картинку
		var sprite_index = i + 1
		while sprite_index > 5:
			sprite_index -= 5
		for j in range(2): # Для каждой карты рандомную координату
			var rand_coord = Vector2(Global.rng.randi_range(0, grid_size.x-1), Global.rng.randi_range(0, grid_size.y-1))
			while grid[rand_coord.x][rand_coord.y].initialized: # Если попадаем на инициализированную карту, меняем координату
				rand_coord = Vector2(Global.rng.randi_range(0, grid_size.x-1), Global.rng.randi_range(0, grid_size.y-1))
			
			grid[rand_coord.x][rand_coord.y].change_sprite(sprite_index)

func check_cards():
	var cards = get_tree().get_nodes_in_group("Card")
	var solved = true
	for i in range(cards.size()-1):
		if !cards[i].solved:
			solved = false
	if solved:
		win_label.text = "Победа!\nНажмите R - для рестарта\nEsc - для выхода"
		

func add_mistakes():
	mistakes += 1
	update_UI()

func add_pairs():
	pairs += 1
	update_UI()

func update_UI():
	mistake_label.text = "Ошибок: " + str(mistakes)
	pairs_label.text = "Раскрыто пар: " + str(pairs)

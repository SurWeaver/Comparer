class_name Card
extends Node2D

signal opened

onready var anim = $AnimationPlayer

export var hidden = true
var initialized = false
var index = 0
var solved = false

# СОБЫТИЯ
func _ready():
	connect("opened", Global, "check_cards")
	anim.play("Setup")

func _on_TextureButton_pressed(): # При открытии, воспроизводится анимация, и карта добавляется в проверку
	if hidden && Global.can_open():
		anim.play("Show")
		Global.add_card(self)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Show":
		emit_signal("opened")

# МЕТОДЫ
func hide():
	anim.play("Hide")

func destroy():
	anim.play("Destroy")
	solved = true

func change_sprite(sprite_index):
	$Sprite.texture = load("res://sprites/" + str(sprite_index) + ".png")
	index = sprite_index
	initialized = true

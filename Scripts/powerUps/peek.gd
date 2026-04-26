extends PowerUp

#if player has atleast two eye cards in deck can see value of next card in deck
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var control: Control = $CanvasLayer/Control

var cardScene = preload("res://Scenes/Card.tscn")

func _ready() -> void:
	super._ready()
	Global.dealtCard.connect(dealtCard)
	canvas_layer.visible = false

func localUse():
	if !checkEyeCount(): return
	
	var card : Card = cardScene.instantiate()
	card.card_id = Global.deck[-1][0]
	card.card_suit = Global.deck[-1][1]
	control.add_child(card)
	
	canvas_layer.visible = true

func canUse():
	if blackJackScene.playerCards.is_empty() or !checkEyeCount():
		return false
	else:
		return true

func checkEyeCount() -> bool:
	var eyeCount = 0
	for card in blackJackScene.playerCards:
		if card.card_suit == 3:
			eyeCount += 1
	if eyeCount >= 2:
		return true
	else:
		return false

func dealtCard(_card : Card):
	for child in control.get_children():
		child.queue_free()
	canvas_layer.visible = false

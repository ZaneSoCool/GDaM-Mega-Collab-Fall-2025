extends Node

var dealer_health_scalar : int = 1
var current_dealer_vitality : int = 0
var vitality : int = 100
var max_vitality : int = 100 #not a cap but a tracker of the highest the player's vitality has reached

var deck : Array[Array] = [] #inner array has two values, index 0 = id, index 1 = suit

signal dealtCard (new_card: Card)

func _ready() -> void:
	#init deck
	for i in 13:
		for j in 4:
			deck.append([i + 1, j + 1])

#stores quantity of power ups player has
var powerUpQuantityDictionary : Dictionary[String, int] = {
	"Equivalent Exchange" : 5,
	"Backjack" : 5,
	"LowBall" : 5,
	"SickleCell" : 5,
	"AceInTheHole" : 5,
	"DoubleDown" : 5,
	"Slurp" : 5,
	"Rawr" : 5,
	"Peek" : 5,
	"SuitSwap" : 5
}

#stores references to the scene of a powerUp
var powerUpRefDictionary : Dictionary[String, String] = {
	"Equivalent Exchange" : "res://Scenes/powerUps/equivalent_exchange.tscn",
	"Backjack" : "res://Scenes/powerUps/back_jack.tscn",
	"LowBall" : "res://Scenes/powerUps/low_ball.tscn",
	"SickleCell" : "res://Scenes/powerUps/sickle_cell.tscn",
	"AceInTheHole" : "res://Scenes/powerUps/ace_in_the_hole.tscn",
	"DoubleDown" : "res://Scenes/powerUps/double_down.tscn",
	"Slurp" : "res://Scenes/powerUps/slurp.tscn",
	"Rawr" : "res://Scenes/powerUps/rawr.tscn",
	"Peek" : "res://Scenes/powerUps/peek.tscn",
	"SuitSwap" : "res://Scenes/powerUps/suit_swap.tscn"
}

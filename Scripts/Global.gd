extends Node

var current_dealer_vitality : int = 100
var vitality : int = 100

#stores quantity of power ups player has
var powerUpQuantityDictionary : Dictionary[String, int] = {
	"Equivalent Exchange" : 1,
	"Backjack" : 1
}

#stores references to the scene of a powerUp
var powerUpRefDictionary : Dictionary[String, String] = {
	"Equivalent Exchange" : "res://Scenes/powerUps/equivalent_exchange.tscn",
	"Backjack" : "res://Scenes/powerUps/back_jack.tscn"
}

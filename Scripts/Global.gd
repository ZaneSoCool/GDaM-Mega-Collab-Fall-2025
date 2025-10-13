extends Node

var current_dealer_vitality : int = 100
var vitality : int = 100

#stores quantity of power ups player has
var powerUpQuantityDictionary : Dictionary[String, int] = {
	"Equivelant Exchange" : 3,
	"We're All In" : 0
}

#stores references to the scene of a powerUp
var powerUpRefDictionary : Dictionary[String, String] = {
	"Equivelant Exchange" : "res://Scenes/powerUps/equivelant_exchange.tscn"
}

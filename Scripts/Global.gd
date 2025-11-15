extends Node

var current_dealer_vitality : int = 0
var vitality : int = 100

#stores quantity of power ups player has
var powerUpQuantityDictionary : Dictionary[String, int] = {
	"Equivalent Exchange" : 0,
	"Backjack" : 0,
	"LowBall" : 0,
	"SickleCell" : 0,
	"AceInTheHole" : 0
}

#stores references to the scene of a powerUp
var powerUpRefDictionary : Dictionary[String, String] = {
	"Equivalent Exchange" : "res://Scenes/powerUps/equivalent_exchange.tscn",
	"Backjack" : "res://Scenes/powerUps/back_jack.tscn",
	"LowBall" : "res://Scenes/powerUps/low_ball.tscn",
	"SickleCell" : "res://Scenes/powerUps/sickle_cell.tscn",
	"AceInTheHole" : "res://Scenes/powerUps/ace_in_the_hole.tscn"
}

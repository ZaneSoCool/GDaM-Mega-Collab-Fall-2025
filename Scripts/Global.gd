extends Node

var current_dealer_vitality : int = 0
var vitality : int = 100
var max_vitality : int = 100 #not a cap but a tracker of the highest the player's vitality has reached

#stores quantity of power ups player has
var powerUpQuantityDictionary : Dictionary[String, int] = {
	"Equivalent Exchange" : 5,
	"Backjack" : 5,
	"LowBall" : 5,
	"SickleCell" : 5,
	"AceInTheHole" : 5,
	"DoubleDown" : 5,
	"Slurp" : 5
}

#stores references to the scene of a powerUp
var powerUpRefDictionary : Dictionary[String, String] = {
	"Equivalent Exchange" : "res://Scenes/powerUps/equivalent_exchange.tscn",
	"Backjack" : "res://Scenes/powerUps/back_jack.tscn",
	"LowBall" : "res://Scenes/powerUps/low_ball.tscn",
	"SickleCell" : "res://Scenes/powerUps/sickle_cell.tscn",
	"AceInTheHole" : "res://Scenes/powerUps/ace_in_the_hole.tscn",
	"DoubleDown" : "res://Scenes/powerUps/double_down.tscn",
	"Slurp" : "res://Scenes/powerUps/slurp.tscn"
}

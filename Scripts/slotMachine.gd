extends Control

@onready var v_box_container: VBoxContainer = $VBoxContainer

@export var symbols : Array[Texture]

var slots = {
	0 : [],
	1 : [],
	2 : []
}

var topPurchased = false
var bottomPurchased = false

func _ready() -> void:
	getSlots()

func _on_spin_button_pressed() -> void:
	for row in slots:
		for slot in slots[row]:
			slot.spin(symbols)
		
	readSlots()

func getSlots():
	for i in v_box_container.get_children().size():
		var hbox = v_box_container.get_child(i)
		for slot in hbox.get_children():
			slots.get(i).append(slot)

func readSlots():
	var wins = 0
	
	var realSymbols = symbols.duplicate() #symbols excluding the joker
	realSymbols.remove_at(4)
	
	for symbol in realSymbols: #loop through each of the 4 symbols
		pass #TODO: FIGURE OUT QUANTIY OF WINS
		
	print(wins)
	giveRewards(wins)
	
func giveRewards(wins : int):
	pass

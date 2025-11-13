extends Control

@onready var v_box_container: VBoxContainer = $VBoxContainer
@export var symbols : Array[Texture]

@export var purchasedTop : bool = false
@export var purchasedBottom : bool = false

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
	for i in range(slots.size()):
		var hbox = v_box_container.get_child(i)
		for slot in hbox.get_children():
			slots.get(i).append(slot)

func readSlots():
	var wins = 0
	
	var realSymbols = symbols.duplicate() #symbols excluding the joker
	realSymbols.remove_at(4)
	
	for symbol in realSymbols: #loop through each of the 4 symbols
		for i in range(-1, 2): #loop through 3 rows
			var x = 0
			var y1 = 1
			if y1+i >= 0 and y1+i < 3 and checkSlot(symbol, x, y1 + i): #check if row is valid
				for j in range(-1, 2): #loop through 3 rows
					x = 1
					var y2 = y1 + i
					if y2+j >= 0 and y2+j < 3 and checkSlot(symbol, x, y2 + j): #check if row is valid
						for k in range(-1, 2): #loop through 3 rows
							x = 2
							var y3 = y2 + j
							if y3+k >= 0 and y3+k < 3 and checkSlot(symbol, x, y3 + k): #check if row is valid
								wins += 1
	
	giveRewards(wins)
	
func giveRewards(wins : int):
	print(wins)

func _on_purchase_top_button_pressed() -> void:
	#if Global.vitality > 20:
		#Global.vitality -= 20
		purchasedTop = true

func _on_purchase_bottom_button_pressed() -> void:
	#if Global.vitality > 20:
		#Global.vitality -= 20
		purchasedBottom = true

func checkSlot(symbol : Texture, x, y): #returns true if slot matches symbol
	if (y == 0 and !purchasedTop) or (y == 2 and !purchasedBottom): #check if purchased row
		return false
	else:
		var slotText = slots[y][x].slotGraphic.texture 
		if slotText == symbol or slotText == symbols[4]: #check if symbols match
			return true
		
	return false

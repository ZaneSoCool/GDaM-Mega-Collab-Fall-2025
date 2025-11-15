extends Control

@onready var grid: GridContainer = $GridContainer
@export var symbols : Array[Texture]

@onready var top_not_purchased: TextureRect = $topNotPurchased
@onready var bottom_not_purchased: TextureRect = $bottomNotPurchased
@onready var vitality_label: Label = $Vitality

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
	vitality_label.text = "Vitality: " + str(Global.vitality)

func _on_spin_button_pressed() -> void:
	for row in slots:
		for slot in slots[row]:
			slot.spin(symbols)
		
	readSlots()
	vitality_label.text = "Vitality: " + str(Global.vitality)

func getSlots():
	for i in range(grid.get_child_count()):
		var row = int(i / 3)
		var slot = grid.get_child(i)
		slots[row].append(slot)

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
	print("slot wins = " + str(wins))
	for win in wins: #gives player a random powerUp for each win
		var powerUpKeys = Global.powerUpQuantityDictionary.keys()
		var randomPowerUpKey = powerUpKeys[randi() % powerUpKeys.size()]
		Global.powerUpQuantityDictionary[randomPowerUpKey] += 1

func _on_purchase_top_button_pressed() -> void:
	#if Global.vitality > 20:
		#Global.vitality -= 20
		purchasedTop = true
		top_not_purchased.visible = false

func _on_purchase_bottom_button_pressed() -> void:
	#if Global.vitality > 20:
		#Global.vitality -= 20
		purchasedBottom = true
		bottom_not_purchased.visible = false

func checkSlot(symbol : Texture, x, y): #returns true if slot matches symbol
	if (y == 0 and !purchasedTop) or (y == 2 and !purchasedBottom): #check if purchased row
		return false
	else:
		var slotText = slots[y][x].slotGraphic.texture 
		if slotText == symbol or slotText == symbols[4]: #check if symbols match
			return true
		
	return false

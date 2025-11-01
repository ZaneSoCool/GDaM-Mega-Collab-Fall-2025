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

		for slot in slots[0]:
			var validSlots1=[] #slots in column 2 which will be valid according to column 1
			
			if slot.slotGraphic.texture == symbol or slot.slotGraphic.texture == symbols[4]:
				var slotIndex1 = slots[0].find(slot)
				validSlots1.append(slots[1][slotIndex1])
				if slotIndex1 - 1 >= 0:
					validSlots1.append(slots[1][slotIndex1-1])
				if slotIndex1 + 1 <= 2:
					validSlots1.append(slots[1][slotIndex1+1])
					
				for slot2 in validSlots1:
					var validSlots2=[] #slots in column 3 which will be valid according to column 2
			
					if slot2.slotGraphic.texture == symbol or slot2.slotGraphic.texture == symbols[4]:
						var slotIndex2 = slots[2].find(slot2)
						validSlots2.append(slots[2][slotIndex2])
						if slotIndex2 - 1 >= 0:
							validSlots2.append(slots[2][slotIndex2-1])
						if slotIndex2 + 1 <= 2:
							validSlots2.append(slots[2][slotIndex2+1])
							
							for slot3 in validSlots2:
								if slot3.slotGraphic.texture == symbol or slot3.slotGraphic.texture == symbols[4]:
									wins += 1
									break
	print(wins)

extends Control
class_name PowerUp

#Written by Zane

#THIS IS A CLASS SCRIPT THAT ALL POWERUPS WILL INHERIT
#call use() on a powerup and it will call it here, then it will call localUse() for powerup specific stuff

@export var powerUpName : String
@export_multiline var description : String
@export var isPassive : bool

var desc_text : Label

var blackJackScene : Node

func _ready() -> void:
	self.text = powerUpName + " " + str(Global.powerUpQuantityDictionary.get(powerUpName))
	blackJackScene = get_tree().current_scene
	
	desc_text = get_parent().get_parent().find_child("PowerUpDescription")

func use():
	if !canUse(): return
	
	#updates quantity of this powerUp left
	Global.powerUpQuantityDictionary[powerUpName] -= 1
	
	#destroys self if player has no more of this powerup
	if Global.powerUpQuantityDictionary[powerUpName] <= 0:
		queue_free()
	else:
		self.text = powerUpName + ": " + str(Global.powerUpQuantityDictionary.get(powerUpName))

	localUse()
	
func localUse():
	pass

func _on_pressed() -> void:
	if isPassive: return
	use()

func checkUse(): #checks if card should be used automatically
	pass

func canUse(): #returns true or false based on if powerup is allowed to be used
	pass

func _on_mouse_entered() -> void:
	if desc_text:
		desc_text.text = description

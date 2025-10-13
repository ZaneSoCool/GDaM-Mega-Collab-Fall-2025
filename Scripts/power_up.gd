extends Control
class_name PowerUp

#THIS IS A CLASS SCRIPT THAT ALL POWERUPS WILL INHERIT
#call use() on a powerup and it will call it here, then it will call localUse() for powerup specific stuff

@export var powerUpName : String

func _ready() -> void:
	self.text = powerUpName

func use():
	#updates quantity of this powerUp left
	Global.powerUpQuantityDictionary[powerUpName] -= 1
	
	#destroys self if player has no more of this powerup
	if Global.powerUpQuantityDictionary[powerUpName] <= 0:
		queue_free()

	localUse()
	
func localUse():
	pass

func _on_pressed() -> void:
	use()

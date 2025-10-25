extends PowerUp

#prevents player from losing when the dealer draws 21

func localUse():
	#get variables
	var blackJackScene = get_tree().current_scene
	
	blackJackScene.dealerHand = 20

func checkUse():
	#get variables
	var blackJackScene = get_tree().current_scene

	#check if dealer has 21
	if blackJackScene.dealerHand == 21:
		use()

extends PowerUp

#discards the last drawn card and gets another

func localUse():
	#get variables
	var blackJackScene = get_tree().current_scene

	#remove last dealt card TODO: CHANGE for different logic l8r
	blackJackScene.removeCard(true, -1)

	#deal a new card
	blackJackScene.dealCard(true, true)

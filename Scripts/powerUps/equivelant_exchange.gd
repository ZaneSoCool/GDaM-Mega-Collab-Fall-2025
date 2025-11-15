extends PowerUp

#discards the last drawn card and gets another

func localUse():
	#remove last dealt card TODO: CHANGE for different logic l8r
	blackJackScene.removeCard(true, -1)

	#deal a new card
	blackJackScene.dealCard(true, true)

func canUse():
	if !blackJackScene.playerCards.is_empty():
		return true
	else:
		return false

extends PowerUp

#pulls an ace from the deck

func localUse():
	blackJackScene.dealSpecificCard(true, true, 1, 0)

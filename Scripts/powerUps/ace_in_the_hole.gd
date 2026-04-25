extends PowerUp

#pulls an ace from the deck

func localUse():
	blackJackScene.dealCard(blackJackScene.playerCards, true, [1,randi_range(1,4)])

func canUse():
	return true

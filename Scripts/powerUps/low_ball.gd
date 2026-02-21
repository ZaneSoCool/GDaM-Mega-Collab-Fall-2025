extends PowerUp

#doubles value of current 1,2,3s

func localUse():
	for card in blackJackScene.playerCards:
		if card.card_id < 4:
			blackJackScene.playerHand += card.card_id
			
	blackJackScene.updateHandValue()

func canUse():
	if blackJackScene.playerCards.is_empty():
		return false
	else:
		for card in blackJackScene.playerCards:
			if card.card_id < 4:
				return true
		return false

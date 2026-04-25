extends PowerUp

#doubles value of current 1,2,3s

func localUse():
	var newPlayerCards : Array[Array] = []
	
	for card in blackJackScene.playerCards:
		if card.card_id <= 4:
			newPlayerCards.append([card.card_id * 2, card.card_suit])
		else:
			newPlayerCards.append([card.card_id, card.card_suit])
		
	blackJackScene.clearCards(blackJackScene.playerCards)
	
	for card in newPlayerCards:
		blackJackScene.dealCard(blackJackScene.playerCards, true, card)
			
	blackJackScene.updateHandValue()

func canUse():
	if blackJackScene.playerCards.is_empty():
		return false
	else:
		for card in blackJackScene.playerCards:
			if card.card_id < 4:
				return true
		return false

extends PowerUp

#halves value of all even cards in current hand (no face cards)

func localUse():
	for card in blackJackScene.playerCards:
		if card.card_id <= 10 and card.card_id % 2 == 0: #makes sure player has an even card
			blackJackScene.playerHand -= card.card_id / 2
			
	blackJackScene.updateHandValue()

func canUse():
	if blackJackScene.playerCards.is_empty():
		return false
	else:
		for card in blackJackScene.playerCards:
			if card.card_id <= 10 and card.card_id % 2 == 0: #makes sure player has an even card
				return true
		return false

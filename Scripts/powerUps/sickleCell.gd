extends PowerUp

#halves value of all even cards in current hand (no face cards)

func localUse():
	var newPlayerCards : Array[Array] = []
	
	for card in blackJackScene.playerCards:
		if card.card_id <= 10 and card.card_id % 2 == 0: #makes sure player has an even card
			newPlayerCards.append([card.card_id / 2, card.card_suit])
		else:
			newPlayerCards.append([card.card_id, card.card_suit])
		
	blackJackScene.clearCards(blackJackScene.playerCards)
	
	for card in newPlayerCards:
		blackJackScene.dealCard(blackJackScene.playerCards, true, card, true)
			
	blackJackScene.updateHandValue()

func canUse():
	if blackJackScene.playerCards.is_empty():
		return false
	else:
		for card in blackJackScene.playerCards:
			if card.card_id <= 10 and card.card_id % 2 == 0: #makes sure player has an even card
				return true
		return false

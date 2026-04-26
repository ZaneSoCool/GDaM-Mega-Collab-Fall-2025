extends PowerUp

func localUse():
	var newPlayerCards : Array[Array] = []
	
	var newSuit = randi_range(1,4)
	
	for card in blackJackScene.playerCards:
		newPlayerCards.append([card.card_id, newSuit])
		
	blackJackScene.clearCards(blackJackScene.playerCards)
	
	for card in newPlayerCards:
		blackJackScene.dealCard(blackJackScene.playerCards, true, card, true)
			
	blackJackScene.updateHandValue()

func canUse():
	if blackJackScene.playerCards.is_empty():
		return false
	else:
		return true

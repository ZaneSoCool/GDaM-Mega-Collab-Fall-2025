extends PowerUp

func localUse():
	for card in blackJackScene.playerCards:
		if card.card_suite == 2: #makes sure card is blood
			Global.current_dealer_vitality -= card.card_id
			if Global.current_dealer_vitality <= 0:
				blackJackScene.dealerLose()
			blackJackScene.removeCard(true, blackJackScene.getCardIndex(card.card_id, card.card_suite))
	blackJackScene.dealer_vitality_bar.value = Global.current_dealer_vitality

func canUse():
	if blackJackScene.playerCards.is_empty():
		return false
	else:
		for card in blackJackScene.playerCards:
			if card.card_suite == 2:
				return true
		return false

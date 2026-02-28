extends PowerUp

func localUse():
	for card in blackJackScene.playerCards:
		if card.card_suite == 4: #makes sure card is blood
			Global.vitality += clampi(card.card_id, 1, 10)
			if Global.vitality >= Global.max_vitality:
				Global.vitality = Global.max_vitality
			
			blackJackScene.removeCard(true, blackJackScene.getCardIndex(card.card_id, card.card_suite))
				
	blackJackScene.player_vitality_bar.value = Global.vitality

func canUse():
	if blackJackScene.playerCards.is_empty() or Global.vitality >= Global.max_vitality:
		return false
	else:
		for card in blackJackScene.playerCards:
			if card.card_suite == 4:
				return true
		return false

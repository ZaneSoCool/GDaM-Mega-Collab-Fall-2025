extends PowerUp

#discards the last drawn card and gets another
var lastDrawnCard : Card = null

func _ready() -> void:
	super._ready()
	Global.dealtCard.connect(dealtCard)

func dealtCard(card : Card):
	lastDrawnCard = card

func localUse():
	#remove card
	blackJackScene.removeCard(blackJackScene.playerCards, blackJackScene.getCardIndex(lastDrawnCard.card_id, lastDrawnCard.card_suit))

	#deal a new card
	blackJackScene.dealCard(blackJackScene.playerCards, true, [])

func canUse():
	if !blackJackScene.playerCards.is_empty() or lastDrawnCard != null:
		return true
	else:
		return false

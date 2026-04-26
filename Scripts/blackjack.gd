extends Control

#Made by Elisa, Garner, Zane, and Christopher

#external variables
@export var dealer_max_vitality : int
@export var minimumBet = 5
@export var AI_hit_stop = 17
@export var AI_randomness = 1 #number of hit range where it may randomly hit
@export var next_scene : String

#internal variables
var playerHandValue = 0
var dealerHandValue = 0
var playerCards : Array[Card] = []
var dealerCards : Array[Card] = []
var passivePowerups = []

#cards in player hand that won't be added back to the deck
var playerTempCards : Array[Card] = []
#cards that were in player hand but removed, to be added back to deck
var playerRemovedCards : Array[Card] = []

var currentBet : int

var twentyOne := 21

#references
	#cards
@onready var player_cards_visualized: HBoxContainer = $PlayerHand/PlayerCardsVisualized
@onready var dealer_cards_visualized: HBoxContainer = $DealerHand/DealersCardsVisualized
@onready var player_hand_value: Label = $PlayerHand/PlayerHandValue
	#interface
@onready var play_buttons: HBoxContainer = $playButtons
@onready var bet_buttons: HBoxContainer = $betButtons
@onready var line_edit: LineEdit = $betButtons/LineEdit
	#data
@onready var current_bet_label: Label = $Data/CurrentBet
@onready var minimum_bet_label: Label = $Data/MinimumBet
@onready var twenty_one_label: Label = $Data/TwentyOne
	#vitality
@onready var player_vitality_bar: ProgressBar = $playerVitalityBar
@onready var dealer_vitality_bar: ProgressBar = $dealerVitalityBar
@onready var player_vitality_bar_label: Label = $playerVitalityBar/Label
@onready var dealer_vitality_bar_label: Label = $dealerVitalityBar/Label


	#powerups
@onready var power_ups: GridContainer = $LeftBar/PowerUps

@onready var winandlose: Label = $winandlose

var cardScene = preload("res://Scenes/Card.tscn")

#setup
func _ready() -> void:
	#-----------init scene-----------
	
	dealer_max_vitality = roundi(dealer_max_vitality * Global.dealer_health_scalar)
	
	#sets up dealer health
	if Global.current_dealer_vitality <= 0:
		Global.current_dealer_vitality = dealer_max_vitality
	
	#setup bet and bet text stuff
	minimum_bet_label.text = "Minimum Bet: " + str(minimumBet)
	currentBet = minimumBet
	current_bet_label.text = "Current Bet: " + str(currentBet)
	line_edit.text = str(currentBet)

	#setup player health bar
	player_vitality_bar.value = Global.vitality
	player_vitality_bar.max_value = Global.max_vitality
	player_vitality_bar_label.text = str(player_vitality_bar.value) + " / " + str(player_vitality_bar.max_value)
	
	#sets up the dealers max vitality if this is the first match against this dealer (this is the case if dealer vitality is <=0)
	if Global.current_dealer_vitality <= 0:
		Global.current_dealer_vitality = dealer_max_vitality
		
	#setup dealer health bar
	dealer_vitality_bar.max_value = dealer_max_vitality
	dealer_vitality_bar.value = Global.current_dealer_vitality
	dealer_vitality_bar_label.text = str(dealer_vitality_bar.value) + " / " + str(dealer_vitality_bar.max_value)
	
	#setup powerUps
	for powerUpKey in Global.powerUpQuantityDictionary:
		if Global.powerUpQuantityDictionary[powerUpKey] > 0:
			var powerUp = load(Global.powerUpRefDictionary[powerUpKey]).instantiate()
			power_ups.add_child(powerUp)
			
			if powerUp.isPassive == true:
				passivePowerups.append(powerUp)
				
	#make correct buttons visible
	play_buttons.visible = false
	
	Global.deck.shuffle()
	
## Deals cards at the start of a new round
func dealCards():
	#deal cards
	dealCard(playerCards, true, [])
	dealCard(playerCards, true, [])
	dealCard(dealerCards, true, [])
	dealCard(dealerCards, false, [])

	play_buttons.visible = true

## Endgame logic for a Blackjack round.
func endGame():
	play_buttons.visible = false
	
	if dealerHandValue > twentyOne or (playerHandValue > dealerHandValue and playerHandValue <= twentyOne):
		Global.current_dealer_vitality -= currentBet
		Global.vitality += currentBet
		
		if Global.vitality > Global.max_vitality: #update max vitality if vitality surpasses it
			Global.max_vitality = Global.vitality
	
		flipAllCards()
		if Global.current_dealer_vitality <= 0:
			dealerLose()

		else:
			transitionNextScene("Hand Won")
		
	else:
		Global.vitality -= currentBet
		flipAllCards()

		if Global.vitality <= 0:
			transitionNextScene("Game Over", "res://Scenes/Menu.tscn")
		else:
			transitionNextScene("Hand Lost")

## Updates dealer's health multiplier, and transitions to the next round
func dealerLose(): # Lowkey unneeded imho
	Global.current_dealer_vitality = 0 
	Global.dealer_health_scalar *= 1.5
	transitionNextScene("Round Won", next_scene)
	
## Shows inputted text onto screen, and transitions to the next scene, if inputted.
##
## [param nextScene] is a filepath, stored as a string. If no scene is inputted, the current scene will reload.
func transitionNextScene(roundText: String, nextScene = null):
	#update & restore deck
	for card in playerRemovedCards:
		playerCards.append(card)
	for card in playerCards:
		if not playerTempCards.has(card):
			Global.deck.append([card.card_id, card.card_suit])
			
	
	#visual queue if player won or lost
	winandlose.text = roundText
	winandlose.visible = true
	await(get_tree().create_timer(2.0).timeout)
	
	#change scene
	if nextScene != null:
		SceneTransition.change_scene_to(nextScene)
	else:
		SceneTransition.restart_current_scene()
	
	
#------------Game/Round Logic------------#

func dealerTurn():
	play_buttons.visible = false
	
	var randomness = randi_range(-AI_randomness, AI_randomness)
	while dealerHandValue < (AI_hit_stop + randomness):
		dealCard(dealerCards, true, [])
		randomness = randi_range(-AI_randomness, AI_randomness)
	
	endGame()


## Deals a card.
##
## Pass in cards [Array of Card] that you are dealing a new card to
## [br] [param faceUp] dictates whether the given card's value can be seen by the player when dealt
## cardToDeal, if null deals random card, else gives specific card
func dealCard(cards : Array[Card], faceUp : bool, cardToDeal : Array):
	var card = cardScene.instantiate()
	var card_info : Array = cardToDeal #index 0 is id, index 1 is suit
	
	if cardToDeal == []: #get random card from deck
		
		if Global.deck.is_empty():
			print("DECK EMPTY ERROR")
			return
		
		card_info = Global.deck[Global.deck.size()-1]
		Global.deck.remove_at(Global.deck.size()-1)
	
	card.card_id = card_info[0]
	card.card_suit = card_info[1]
	card.faceUp = faceUp
	
	if cards == playerCards:
		Global.dealtCard.emit(card)
	
	cards.append(card)
	
	totalHand(cards)
	
	#add cards to UI
	if cards == playerCards:
		player_cards_visualized.add_child(card)
	else:
		dealer_cards_visualized.add_child(card)
		
	checkEndGame()

## Sums up the total hand value for the player/dealer 
func totalHand(hand : Array[Card]):
	sortCards(hand)
	
	if hand == playerCards:
		playerHandValue = sumCardHand(hand)
	elif hand == dealerCards:
		dealerHandValue = sumCardHand(hand)
		
	updateHandValue()

## [b][i][u]ACTUALLY[/u][/i][/b]
## sums up the the total hand value for the given player, and returns it.
## [param cards] ocontains all of the player's dealt cards.
## Helper to totalHand -- DO NOT USE OUTSIDE OF totalHand!
func sumCardHand(hand: Array[Card]):
	var handValue = 0
	for card in hand:
		if card.card_id > 10:
			handValue += 10
		elif card.card_id == 1:
			if handValue + 11 > twentyOne:
				handValue += 1
			else:
				handValue += 11
		else:
			handValue += card.card_id
	return handValue

#------------- Buttons Pressed -------------

## Hit button
func _on_hit_pressed() -> void:
	dealCard(playerCards, true, [])

## Stand button
func _on_stand_pressed() -> void:
	dealerTurn()

## Double Down button (NOT POWERUP)
func _on_double_down_pressed() -> void:
	if currentBet * 2 > Global.vitality:
		return
	else:
		currentBet *= 2
		dealCard(playerCards, true, [])
		dealerTurn()

func _on_submit_pressed() -> void:
	var bet = int(line_edit.text)
	if bet < minimumBet or bet > Global.vitality or bet > Global.current_dealer_vitality:
		return
		
	currentBet = bet
	current_bet_label.text = "Current Bet: " + str(bet)
	bet_buttons.visible = false
	
	dealCards()

#----------------Extra-Powerup-Logic--------------------

## Removes the [param cardIndex]-th card from the chosen player's hand.
func removeCard(cards : Array[Card], cardIndex : int):
	removeCardHelper(cards, cardIndex)
	totalHand(cards)

## Actually removes the card from the provided deck, and subtracts its worth from the player's hand total.
func removeCardHelper(cards: Array[Card], cardIndex: int):
	if cards.is_empty(): return
		
	var cardToRemove = cards[cardIndex]

	var cardValue = cardToRemove.card_id
	
	#get rid of stuff
	if cards == playerCards:
		playerRemovedCards.append(cardToRemove)
	cards.remove_at(cardIndex)
	cardToRemove.queue_free()

func clearCards(cards : Array[Card]):
	if cards == playerCards:
		playerRemovedCards = playerRemovedCards + cards
	
	for card in cards:
		card.queue_free()
	cards.clear()
	
	totalHand(cards)

## Updates hand value for the player
func updateHandValue():
	player_hand_value.text = "Hand Value : " + str(playerHandValue)

func checkEndGame():
	for powerUp in passivePowerups:
		powerUp.checkUse()
				
	#endgame check
	if playerHandValue > twentyOne or dealerHandValue >= twentyOne:
		endGame()
		
## Gets the index for a given card
func getCardIndex(id : int, suit : int):
	for i in playerCards.size():
		var card = playerCards[i]
		if card.card_id == id and card.card_suit == suit:
			return i

## Flips all cards
func flipAllCards():
	var allCards = dealerCards+playerCards
	for card in allCards:
		card.setup_card_texture(card.card_id, card.card_suit)

## Sorts card for the given hand of dealt cards
func sortCards(hand : Array[Card]):
	hand.sort_custom(func(a, b): return a.card_id > b.card_id)

extends Control

#Made by Elisa, Garner, and Zane

#external variables
@export var dealer_max_vitality : int
@export var minimumBet = 5
@export var AI_hit_stop = 17
@export var AI_randomness = 1 #number of hit range where it may randomly hit
@export var next_scene : String

#internal variables
var playerHand = 0
var dealerHand = 0
var playerCards = []
var dealerCards = []
var passivePowerups = []

var deck : Array[Array] = []
var playing : bool = true
var currentBet : int

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
	#vitality
@onready var player_vitality_bar: ProgressBar = $playerVitalityBar
@onready var dealer_vitality_bar: ProgressBar = $dealerVitalityBar
	#powerups
@onready var power_ups: HBoxContainer = $PowerUps
@onready var power_ups_passive: HBoxContainer = $PowerUpsPassive

var cardScene = preload("res://Scenes/Card.tscn")

#setup
func _ready() -> void:
	#-----------init scene-----------
	
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
	
	#sets up the dealers max vitality if this is the first match against this dealer (this is the case if dealer vitality is <=0)
	if Global.current_dealer_vitality <= 0:
		Global.current_dealer_vitality = dealer_max_vitality
		
	#setup dealer health bar
	dealer_vitality_bar.max_value = dealer_max_vitality
	dealer_vitality_bar.value = Global.current_dealer_vitality
	
	#setup powerUps
	for powerUpKey in Global.powerUpQuantityDictionary:
		if Global.powerUpQuantityDictionary[powerUpKey] > 0:
			var powerUp = load(Global.powerUpRefDictionary[powerUpKey]).instantiate()
			if powerUp.isPassive == false:
				power_ups.add_child(powerUp)
			else:
				power_ups_passive.add_child(powerUp)
				passivePowerups.append(powerUp)
				
	#make correct buttons visible
	play_buttons.visible = false
	
	#init deck
	for i in 4:
		for j in 13:
			deck.append([j + 1, i + 1])
	deck.shuffle()
	
func dealCards():
	#deal cards
	dealCard(true, true)
	dealCard(true, true)
	dealCard(false, true)
	dealCard(false, false)

	play_buttons.visible = true
	
func endGame():
	playing = false
	play_buttons.visible = false
	
	if dealerHand > 21 or (playerHand > dealerHand and playerHand <= 21):
		Global.current_dealer_vitality -= currentBet
		Global.vitality += currentBet
		
		if Global.vitality > Global.max_vitality: #update max vitality if vitality surpasses it
			Global.max_vitality = Global.vitality
	
		if Global.current_dealer_vitality <= 0:
			Global.current_dealer_vitality = 0
			print("next level")
			SceneTransition.change_scene_to(next_scene)
		else:
			print("player won : new round")
			SceneTransition.reload_current_scene()
		
	else:
		Global.vitality -= currentBet
		
		if Global.vitality <= 0:
			print("game over")
			SceneTransition.change_scene_to("res://Scenes/Menu.tscn")
		else:
			print("player lost : new round")
			SceneTransition.reload_current_scene()
	
#------------Game/Round Logic------------#

func dealerTurn():
	play_buttons.visible = false
	
	while playing:
		var randomness = randi_range(-AI_randomness, AI_randomness)
		if dealerHand < (AI_hit_stop + randomness):
			dealCard(false, true)
		else:
			endGame()

func dealCard(forPlayer : bool, faceUp : bool):
	var card = cardScene.instantiate()
	
	var card_info = deck[deck.size()-1]
	deck.remove_at(deck.size()-1)
	
	card.card_id = card_info[0]
	card.card_suite = card_info[1]
	card.faceUp = faceUp
	
	if forPlayer:
		playerCards.append(card)
		totalHand(forPlayer, card_info)
		player_cards_visualized.add_child(card)
	else:
		dealerCards.append(card)
		totalHand(forPlayer, card_info)
		dealer_cards_visualized.add_child(card)
		
	checkEndGame()
		
func dealSpecificCard(forPlayer : bool, faceUp : bool, card_id : int, card_suit : int): #if card id or suit is 0 it will be random
	var card = cardScene.instantiate()
	
	var card_info : Array #finds suitable card
	for i in range(deck.size()):
		if card_info.is_empty():
			var deckCard = deck[i]
			if (card_id == 0 or deckCard[0] == card_id) and (card_suit == 0 or deckCard[1] == card_suit):
				card_info = deckCard.duplicate()
				deck.remove_at(i)
				
	if card_info.is_empty(): #deck has no matching cards
		print("AHH FUCK")
		return
	
	card.card_id = card_info[0]
	card.card_suite = card_info[1]
	card.faceUp = faceUp
	
	if forPlayer:
		playerCards.append(card)
		totalHand(forPlayer, card_info)
		player_cards_visualized.add_child(card)
	else:
		dealerCards.append(card)
		totalHand(forPlayer, card_info)
		dealer_cards_visualized.add_child(card)
		
	checkEndGame()

#sums up hand for stuff
func totalHand(forPlayer : bool, card_info : Array):
	
	if forPlayer:
		if card_info[0] > 10:
			playerHand += 10
		elif card_info[0] == 1:
			if playerHand + 11 > 21:
				playerHand += 1
			else:
				playerHand += 11
		else:
			playerHand += card_info[0]
	else:
		if card_info[0] > 10:
			dealerHand += 10
		elif card_info[0] == 1:
			if dealerHand + 11 > 21:
				dealerHand += 1
			else:
				dealerHand += 11
		else:
			dealerHand += card_info[0]
			
	updateHandValue()

#------------- Buttons Pressed -------------

#Hit
func _on_hit_pressed() -> void:
	dealCard(true, true)

#Stand
func _on_stand_pressed() -> void:
	dealerTurn()

#Double Down
func _on_double_down_pressed() -> void:
	if currentBet * 2 > Global.vitality:
		return
	else:
		currentBet *= 2
		dealCard(true, true)
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

func removeCard(forPlayer : bool, cardIndex : int):
	if forPlayer:
		if playerCards.is_empty(): return
		
		var cardToRemove = playerCards[cardIndex]
		var cardValue = cardToRemove.card_id
		
		if cardValue >= 10:
			playerHand -= 10
		elif cardValue == 1:
			if playerHand - 11 <= 0: ##TODO this check is insufficient
				playerHand -= 1
			else:
				playerHand -= 11
		else:
			playerHand -= cardValue
			
		#get rid of stuff
		playerCards.remove_at(cardIndex)
		cardToRemove.queue_free()
	else:
		if dealerCards.is_empty(): return
		
		var cardToRemove = dealerCards[cardIndex]
		var cardValue = cardToRemove.card_id
		
		if cardValue >= 10:
			dealerHand -= 10
		elif cardValue == 1:
			if dealerHand - 11 <= 0: ##TODO this check is insufficient
				dealerHand -= 1
			else:
				dealerHand -= 11
		else:
			dealerHand -= cardValue
			
		#get rid of stuff
		dealerCards.remove_at(cardIndex)
		cardToRemove.queue_free()
	
func updateHandValue():
	player_hand_value.text = "Hand Value : " + str(playerHand)

func checkEndGame():
	for powerUp in passivePowerups:
		powerUp.checkUse()
				
	#endgame check
	if playerHand > 21 or dealerHand >= 21:
		endGame()

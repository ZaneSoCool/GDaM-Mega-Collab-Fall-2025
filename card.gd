extends Node2D

var card_id: int 
@export var sprite: Sprite2D #declaring variable sprite of type Sprite2D.. export lets us see in inspector

static func create(id : int) -> Node2D: #so we can just call Card.create in BlackJack scene
    var scene = preload("res://Card.tscn")
    var card = scene.instantiate()
    card.set_card(id)
    return card

func set_card_id(id: int): #setter for id
    card_id = id
    var texture_path = "res://assets/cards/%d.png" % id
    $Sprite2D.texture = load(texture_path)

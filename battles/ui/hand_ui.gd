extends HBoxContainer

signal card_added(card, sprites)
signal card_removed(card, sprites)

func connect_to_hero_hand():
  var hero = BM.get_hero()
  for c in hero.get_children():
    print( c.name )
  var hand = hero.get_node( 'Hand' )
  hand.connect( 'card_added', self, '_on_hand_card_added' )
  hand.connect( 'card_removed', self, '_on_hand_card_removed' )

func _on_hand_card_added( card, hand ):
  add_card( card )

func _on_hand_card_removed( card, hand ):
  for c in get_children():
    if c.CARD == card:
      remove_card( card, c )

func add_card( card ):
  var card_sprite = card.get_as_ui_element()
  add_child( card_sprite )

  card_sprite.connect( 'card_played', self, 'remove_card' )
  card_sprite.connect( 'card_discarded', self, 'remove_card' )

  emit_signal( 'card_added', card, get_children() )

  # TODO properly scale cards with card_sprite.set_size_params()

  return card_sprite

func remove_card( card, sprite ):
  if sprite in get_children():
    free_sprite( sprite )
    emit_signal( 'card_removed', card, get_children() )

func free_sprite( sprite ):
  # TODO actual animation
  sprite.queue_free()

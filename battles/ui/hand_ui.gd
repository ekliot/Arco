extends HBoxContainer

signal card_added(card, sprites)
signal card_removed(card, sprites)

func _on_hand_card_added( card, hand ):
  add_card( card )

func _on_hand_card_removed( card, hand ):
  for c in get_children():
    if c.CARD == card:
      remove_card( c )
      return

func add_card( card ):
  var card_sprite = card.get_as_ui_element()

  add_child( card_sprite )
  # card_sprite.connect( 'card_played', self, 'remove_card' )
  card_sprite.connect( 'card_discarded', self, 'remove_card' )

  # emit_signal( 'card_added', card_sprite, get_children() )

  # TODO properly scale cards with card_sprite.set_size_params()

  return card_sprite

func remove_card( sprite ):
  if sprite in get_children():
    emit_signal( 'card_removed', sprite, get_children() )
    sprite.to_discard()

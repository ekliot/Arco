extends HBoxContainer

signal empty()
signal card_added(card, sprites)
signal card_removed(card, reason, sprites)

func _on_card_played( card ):
  var sprite = get_card_sprite( card )
  if sprite:
    remove_card( sprite, 'played' )

func _on_card_discarded( card ):
  var sprite = get_card_sprite( card )
  if sprite:
    remove_card( sprite, 'discarded' )

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
  # TODO properly scale cards with card_sprite.set_size_params()

  return card_sprite

func remove_card( sprite, reason ):
  if sprite in get_children():
    sprite.remove( reason )
    var key = yield( sprite, 'tween_complete' )
    # TODO match functionality to key

    remove_child( sprite )
    sprite.queue_free()

    emit_signal( 'card_removed', sprite, reason, get_children() )
    if not get_child_count():
      emit_signal( 'empty' )

func get_card_sprite( card ):
  for c in get_children():
    if c.CARD == card:
      return c
  return null

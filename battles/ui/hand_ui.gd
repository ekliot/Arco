extends HBoxContainer

func add_card( card ):
  var card_sprite = card.get_as_ui_element()
  card_sprite.connect( 'card_placed', self, 'remove_card' )
  add_child( card_sprite )
  # TODO properly scale cards with card_sprite.set_size_params()
  return card_sprite

func remove_card( sprite ):
  # TODO actual animation
  sprite.queue_free()

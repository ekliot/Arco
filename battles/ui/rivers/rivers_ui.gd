extends VBoxContainer

var MODEL = null

# whether the UI element is available for Player control
var enabled = true

# == SETUP == #

func connect_to_model( rivers_model ):
  MODEL = rivers_model
  for id in rivers_model.RIVER_IDS:
    var riv_model = rivers_model.get_river( id )
    get_node( id.to_upper() ).connect_to_model( riv_model )

# == CORE == #

func reverse():
  # reverse each river
  pass

func can_place_card( card, river ):
  return enabled && get_river( river ).can_place_card( card )

func place_card( card, river ):
  var river_step = get_river_step( river, card.get_power() )
  river_step.place_card( card )

func enable():
  enabled = true

func disable():
  enabled = false

# == GETTERS == #

func is_enabled():
  return enabled

func get_all_rivers():
  var rivs = []
  for child in get_children():
    if child.has_method( 'connect_to_model' ): # HACK is there a better way to do this?
      rivs.push_back( child )
  return rivs

func get_river( id ):
  return get_node( id.to_upper() )

func get_river_step( id, momentum ):
  return get_river( id ).get_step( momentum )

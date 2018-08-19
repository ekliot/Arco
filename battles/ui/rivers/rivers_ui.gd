extends VBoxContainer

const RiverUI = preload( "river_ui.gd" )

var MODEL = null

# == SETUP == #

func connect_to_model( rivers_model ):
  MODEL = rivers_model
  # propogate to child UI elements
  for id in get_river_ids():
    var riv_model = rivers_model.get_river( id )
    get_river( id ).connect_to_model( riv_model )

func connect_to_card_pointer( card, pointer ):
  print( 'connecting pointer ', pointer, ' from card ', card, ' to steps ', get_valid_steps( card ) )
  for step in get_valid_steps( card ):
    step.connect( 'pointer_lockon', pointer, 'lock_to' )
    step.connect( 'pointer_unlock', pointer, 'unlock' )

# == CORE == #

func reverse():
  # reverse each river
  pass

func valid_for( card ):
  return MODEL.valid_for( card )

func can_place_card( card, river ):
  return valid_for( card ) && MODEL.can_place_card( card, river )

func place_card( card, river ):
  # var river_step = get_river_step( river, card.get_power() )
  # river_step.place_card( card )
  pass

# == GETTERS == #

func get_river_ids():
  return MODEL.RIVER_IDS

func get_all_rivers():
  # TODO
  var rivs = []
  for child in get_children():
    # if child.has_method( 'connect_to_model' ): # HACK is there a better way to do this?
    if child is RiverUI:
      rivs.push_back( child )
  return rivs

func get_river( id ):
  return get_node( id.to_upper() )

func get_river_step( id, momentum ):
  return get_river( id ).get_step( momentum )

func get_valid_steps( card ):
  var steps = []

  for step in MODEL.get_valid_steps( card ):
    steps.push_back( get_river_step( step.get_river_id(), step.get_momentum() ) )

  return steps

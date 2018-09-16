extends Node

# TODO make this a class
func enemy_template( name="" ):
  var template = {
    'id': "ENEMY_%s" % name.to_upper(),
    'sprite': Sprite.new(),
    'stats': {
      'health': -1,
      'health_max': -1,
      'gold': -1,
      'draw_size': 4
    },
    'cards': {
      'deck': DEALER.tmp_deck( BM.CPU ),
      # idx [1:4] correspond to momentum levels 1-4 ; idx 0 unused
      'signature': []
    }
  }

  template.sprite.name = "%sSprite" % BM.fighter_id_to_str( BM.CPU )

  return template

func build_enemy_template( name="", stats={}, cards=[], sprite=null ):
  return enemy_template( name )

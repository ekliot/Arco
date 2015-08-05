import luxe.options.SpriteOptions;

typedef CardOptions = {
    > SpriteOptions,

    var rank : Int;

    var suit : EnumValue;

    var played_from : String;
}

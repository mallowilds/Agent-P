//                              ARTICLE  STUFF                                //

// sprite and mask indexes; + default article variables
sprite_index = sprite_get("dspecial_art");
mask_index = asset_get("dspecial_art"); // idk lol
can_be_grounded = true;
ignores_walls = false;
spr_dir = player_id.spr_dir;

uses_shader = true;

// state machine variables
state = 0;
state_timer = 0;
should_die = false; //if the article should be despawned

is_default = player_id.is_default;
is_ea = player_id.is_ea;

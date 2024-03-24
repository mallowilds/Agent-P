//                              ARTICLE  STUFF                                //

// sprite and mask indexes; + default article variables
sprite_index = sprite_get(player_id.is_ea ? "dspecial_art_ea" : "dspecial_art");
mask_index = asset_get("dspecial_art"); // idk lol
collision_index = asset_get("dspecial_art"); // idk lol
can_be_grounded = true;
ignores_walls = false;
spr_dir = player_id.spr_dir;
depth = -10;

uses_shader = true;

// state machine variables
state = 0;
state_timer = 0;
should_die = false; //if the article should be despawned

is_default = player_id.is_default;
is_ea = player_id.is_ea;

falling_hitbox = noone;
falling_hitbox_hit = false;

trigger_w = 40;
trigger_h = 6;
trigger_h_hitstun = 50;
hitstun_triggered = false;

hud_offset = 90;
max_primed_lifetime = 1800;

vis_warn_phase = -1;
vis_warn_y_offset = 0;

hitbox_type = 1;
HB_DEFAULT = 1;
HB_DRONE = 2;
HB_RUNE_DRONE = 3;
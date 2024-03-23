var atk             = AT_DSPECIAL_AIR;
var window_num      = 1;
var window_length   = 0;

//Perry will put a SSSN-Grade Landmine into the ground, which detonates when stepped on, or if an opponent is hit next to/into it.
//It should send straight up with decent KB but low scaling, its a combo move.
//Perry cannot make a new one while the previous is out, but he can use the move again without spawning it (with a cooldown, and less height but still a slight stall in the air.)

//If Perry uses the move in the air, he should get a slight boost and shoot a projectile down - The projectile is a weak spike that goes through opponents, and if it lands on the ground, it will create the mine.
//If Pery is parachuting during this move, the aerial boost should be a bit higher - Intended to be used as an extra recovery tool.

//If its parried, it should go haywire and disable itself for a few seconds, like Lily. Might also make this disable the drone, but idk probably not it'd be pretty random.

//                        --attack windows--                                  //
set_attack_value(atk, AG_SPRITE                         , sprite_get("dspecial_air"));
set_attack_value(atk, AG_HURTBOX_SPRITE                 , sprite_get("dspecial_air_hurt"));
set_attack_value(atk, AG_NUM_WINDOWS                    , 2);
set_attack_value(atk, AG_CATEGORY                       , 2);
set_attack_value(atk, AG_ATTACK_AIR_LIMIT               , true);

set_window_value(atk, window_num                        , AG_WINDOW_TYPE, 0);
set_window_value(atk, window_num                        , AG_WINDOW_LENGTH, 13);
    var window_length = get_window_value(atk,window_num , AG_WINDOW_LENGTH);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAME_START, 0);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAMES, 3);
set_window_value(atk, window_num                        , AG_WINDOW_HAS_SFX, true);
set_window_value(atk, window_num                        , AG_WINDOW_SFX, asset_get("sfx_swipe_medium1"));
set_window_value(atk, window_num                        , AG_WINDOW_SFX_FRAME, window_length-1);
window_num++;

set_window_value(atk, window_num                        , AG_WINDOW_TYPE, 0);
set_window_value(atk, window_num                        , AG_WINDOW_LENGTH, 24);
    var window_length = get_window_value(atk,window_num , AG_WINDOW_LENGTH);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAME_START, 3);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAMES, 4);

window_num++;

//                        --attack hitboxes--                                 //
set_num_hitboxes(atk, 0); //

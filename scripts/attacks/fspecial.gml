var atk             = AT_FSPECIAL;
var window_num      = 1;
var window_length   = 0;

/* Fspecial 1 - Grapple Gun 
    (xF means anim frames, will change once sketch is finished, but just for ease of implimentation)
    Without a neutral special Point out, this move is a simple forward aiming grappling gun attack.
    After startup (0F), Perry will shoot out the hook (Fspec_proj), which travels forwards quickly before stopping when reaching a certain length. 
    During this, perry will hold his hook out (1-3F), staying on the 4th frame until the hook returns or it hits), and cant move. 
    If the hook misses, it will return back to perry somewhat slowly, and once it returns, perry will go into endlag (4-6F).
    If the hook lands, perry will fly towards the opponent (8F), and once he makes contact, will do a followup that sends up and gives perry VSP so he can combo off of it (7-10f).
*/


//                        --attack windows--                                  //
set_attack_value(atk, AG_SPRITE                         , sprite_get("fspec_base"));
set_attack_value(atk, AG_HURTBOX_SPRITE                 , sprite_get("fspecial_hurt"));
set_attack_value(atk, AG_NUM_WINDOWS                    , 4);
set_attack_value(atk, AG_CATEGORY                       , 2);
set_attack_value(atk, AG_ATTACK_AIR_LIMIT               , true);

// startup
set_window_value(atk, window_num                        , AG_WINDOW_TYPE, 0);
set_window_value(atk, window_num                        , AG_WINDOW_LENGTH, 7);
    var window_length = get_window_value(atk,window_num , AG_WINDOW_LENGTH);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAME_START, 0);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAMES, 1);
set_window_value(atk, window_num                        , AG_WINDOW_HAS_SFX, true);
set_window_value(atk, window_num                        , AG_WINDOW_SFX, asset_get("sfx_may_arc_cointoss"));
set_window_value(atk, window_num                        , AG_WINDOW_SFX_FRAME, window_length-1);
window_num++;

// fire
set_window_value(atk, window_num                        , AG_WINDOW_TYPE, 0);
set_window_value(atk, window_num                        , AG_WINDOW_LENGTH, 6);
    var window_length = get_window_value(atk,window_num , AG_WINDOW_LENGTH);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAME_START, 1);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAMES, 3);
//set_window_value(atk, window_num                        , AG_WINDOW_CAN_WALLJUMP, true);
window_num++;

// loop (await)
set_window_value(atk, window_num                        , AG_WINDOW_TYPE, 9);
set_window_value(atk, window_num                        , AG_WINDOW_LENGTH, 6);
    var window_length = get_window_value(atk,window_num , AG_WINDOW_LENGTH);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAME_START, 4);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAMES, 1);
//set_window_value(atk, window_num                        , AG_WINDOW_CAN_WALLJUMP, true);
window_num++;

// endlagss
set_window_value(atk, window_num                        , AG_WINDOW_TYPE, 0);
set_window_value(atk, window_num                        , AG_WINDOW_LENGTH, 10);
    var window_length = get_window_value(atk,window_num , AG_WINDOW_LENGTH);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAME_START, 4);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAMES, 3);
set_window_value(atk, window_num                        , AG_WINDOW_CAN_WALLJUMP, true);
window_num++;

//                        --attack hitboxes--                                 //
set_num_hitboxes(atk, 1);
var hbox_num = 1;

set_hitbox_value(atk, hbox_num, HG_HITBOX_TYPE              , 2);
set_hitbox_value(atk, hbox_num, HG_WINDOW                   , 0); // spawned manually
set_hitbox_value(atk, hbox_num, HG_WINDOW_CREATION_FRAME    , 0);
set_hitbox_value(atk, hbox_num, HG_LIFETIME                 , 60);
//set_hitbox_value(atk, hbox_num, HG_HITBOX_X                 , 32);
//set_hitbox_value(atk, hbox_num, HG_HITBOX_Y                 , -32);
set_hitbox_value(atk, hbox_num, HG_SHAPE                    , 2);
set_hitbox_value(atk, hbox_num, HG_WIDTH                    , 12);
set_hitbox_value(atk, hbox_num, HG_HEIGHT                   , 28);
set_hitbox_value(atk, hbox_num, HG_PRIORITY                 , 1);
set_hitbox_value(atk, hbox_num, HG_DAMAGE                   , 4);
set_hitbox_value(atk, hbox_num, HG_ANGLE                    , 90);
set_hitbox_value(atk, hbox_num, HG_BASE_KNOCKBACK           , 6);
set_hitbox_value(atk, hbox_num, HG_KNOCKBACK_SCALING        , 0.3);
set_hitbox_value(atk, hbox_num, HG_BASE_HITPAUSE            , 6);
set_hitbox_value(atk, hbox_num, HG_HITPAUSE_SCALING         , 0.3);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT            , 1);
set_hitbox_value(atk, hbox_num, HG_HIT_SFX                  , asset_get("sfx_blow_weak2"));
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_SPRITE        , sprite_get("null"));
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_MASK          , -1);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_DESTROY_EFFECT, hfx_null);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_WALL_BEHAVIOR , 0);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_GROUND_BEHAVIOR, 0);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_ENEMY_BEHAVIOR, 0);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_UNBASHABLE    , true);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_PARRY_STUN    , true);
set_hitbox_value(atk, hbox_num, HG_PROJECTILE_DOES_NOT_REFLECT, true);
hbox_num++;
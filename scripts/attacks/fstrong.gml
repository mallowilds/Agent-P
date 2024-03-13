var atk             = AT_FSTRONG;
var window_num      = 1;
var window_length   = 0;

//                        --attack windows--                                  //
set_attack_value(atk, AG_SPRITE                         , sprite_get("fstrong"));
set_attack_value(atk, AG_HURTBOX_SPRITE                 , hurtbox_spr);
set_attack_value(atk, AG_NUM_WINDOWS                    , 4);
set_attack_value(atk, AG_STRONG_CHARGE_WINDOW           , 1);
set_attack_value(atk, AG_CATEGORY                       , 0);

set_window_value(atk, window_num                        , AG_WINDOW_TYPE, 0);
set_window_value(atk, window_num                        , AG_WINDOW_HAS_CHARGE_LOOP, 1);
set_window_value(atk, window_num                        , AG_WINDOW_CHARGE_FRAME_START, 1);
set_window_value(atk, window_num                        , AG_WINDOW_CHARGE_FRAMES, 2);
set_window_value(atk, window_num                        , AG_WINDOW_CHARGE_LOOP_SPEED, .3);
set_window_value(atk, window_num                        , AG_WINDOW_LENGTH, 10);
    var window_length = get_window_value(atk,window_num , AG_WINDOW_LENGTH);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAME_START, 0);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAMES, 2);
set_window_value(atk, window_num                        , AG_WINDOW_HAS_SFX, true);
window_num++;

set_window_value(atk, window_num                        , AG_WINDOW_TYPE, 0);
set_window_value(atk, window_num                        , AG_WINDOW_LENGTH, 5);
    var window_length = get_window_value(atk,window_num , AG_WINDOW_LENGTH);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAME_START, 3);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAMES, 2);
set_window_value(atk, window_num                        , AG_WINDOW_HSPEED_TYPE, 1);
set_window_value(atk, window_num                        , AG_WINDOW_HAS_SFX, true);
set_window_value(atk, window_num                        , AG_WINDOW_SFX, asset_get("sfx_swipe_heavy1"));
set_window_value(atk, window_num                        , AG_WINDOW_SFX_FRAME, window_length-1);
window_num++;

set_window_value(atk, window_num                        , AG_WINDOW_TYPE, 0);
set_window_value(atk, window_num                        , AG_WINDOW_LENGTH, 3);
    var window_length = get_window_value(atk,window_num , AG_WINDOW_LENGTH);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAME_START, 5);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAMES, 1);
window_num++;

set_window_value(atk, window_num                        , AG_WINDOW_TYPE, 0);
set_window_value(atk, window_num                        , AG_WINDOW_LENGTH, 24);
    var window_length = get_window_value(atk,window_num , AG_WINDOW_LENGTH);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAME_START, 6);
set_window_value(atk, window_num                        , AG_WINDOW_ANIM_FRAMES, 2);
set_window_value(atk, window_num                        , AG_WINDOW_HAS_WHIFFLAG, 1);
window_num++;

//                        --attack hitboxes--                                 //
set_num_hitboxes(atk, 3);
var hbox_num = 1;

set_hitbox_value(atk, hbox_num, HG_HITBOX_TYPE              , 1);
set_hitbox_value(atk, hbox_num, HG_HITBOX_GROUP             , -1);
//set_hitbox_value(atk, hbox_num, HG_WINDOW                   , 3);
//set_hitbox_value(atk, hbox_num, HG_WINDOW_CREATION_FRAME    , 2);
set_hitbox_value(atk, hbox_num, HG_LIFETIME                 , 1);
set_hitbox_value(atk, hbox_num, HG_HITBOX_X                 , -20);
set_hitbox_value(atk, hbox_num, HG_HITBOX_Y                 , -20);
set_hitbox_value(atk, hbox_num, HG_WIDTH                    , 50);
set_hitbox_value(atk, hbox_num, HG_HEIGHT                   , 50);
//set_hitbox_value(atk, hbox_num, HG_HAS_LERP                 , 1);
set_hitbox_value(atk, hbox_num, HG_LERP_PERCENT             , .1);
set_hitbox_value(atk, hbox_num, HG_LERP_POS_X               , 50);
set_hitbox_value(atk, hbox_num, HG_LERP_POS_Y               , 0);
set_hitbox_value(atk, hbox_num, HG_BASE_KNOCKBACK           , 4);
set_hitbox_value(atk, hbox_num, HG_PRIORITY                 , 1);
set_hitbox_value(atk, hbox_num, HG_DAMAGE                   , 1);
set_hitbox_value(atk, hbox_num, HG_ANGLE                    , 30);
set_hitbox_value(atk, hbox_num, HG_BASE_KNOCKBACK           , 2);
set_hitbox_value(atk, hbox_num, HG_BASE_HITPAUSE            , 6);
set_hitbox_value(atk, hbox_num, HG_FORCE_FLINCH             , 1);
set_hitbox_value(atk, hbox_num, HG_HITSTUN_MULTIPLIER       , .4);

set_hitbox_value(atk, hbox_num, HG_HIT_SFX                  , asset_get("sfx_blow_medium3"));
hbox_num++;

set_hitbox_value(atk, hbox_num, HG_HITBOX_TYPE              , 1);
set_hitbox_value(atk, hbox_num, HG_HITBOX_GROUP             , -1);
set_hitbox_value(atk, hbox_num, HG_WINDOW                   , 3);
set_hitbox_value(atk, hbox_num, HG_LIFETIME                 , 2);
set_hitbox_value(atk, hbox_num, HG_HITBOX_X                 , 20);
set_hitbox_value(atk, hbox_num, HG_HITBOX_Y                 , -36);
set_hitbox_value(atk, hbox_num, HG_WIDTH                    , 84);
set_hitbox_value(atk, hbox_num, HG_HEIGHT                   , 84);
set_hitbox_value(atk, hbox_num, HG_PRIORITY                 , 1);
set_hitbox_value(atk, hbox_num, HG_DAMAGE                   , 8);
set_hitbox_value(atk, hbox_num, HG_ANGLE                    , 45);
set_hitbox_value(atk, hbox_num, HG_BASE_KNOCKBACK           , 9);
set_hitbox_value(atk, hbox_num, HG_KNOCKBACK_SCALING        , 0.9);
set_hitbox_value(atk, hbox_num, HG_BASE_HITPAUSE            , 7);
set_hitbox_value(atk, hbox_num, HG_HITPAUSE_SCALING         , 0.9);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT            , 304);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT_X_OFFSET   , 45);
set_hitbox_value(atk, hbox_num, HG_VISUAL_EFFECT_Y_OFFSET   , -5);
set_hitbox_value(atk, hbox_num, HG_HIT_SFX                  , asset_get("sfx_blow_heavy1"));
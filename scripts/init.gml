
#macro GRAPPLE_DISABLED 0
#macro GRAPPLE_ACTIVE 1
#macro GRAPPLE_RETURNING 2
#macro GRAPPLE_PLAYER_MOUNTED 3
#macro GRAPPLE_WALL_MOUNTED 4
#macro GRAPPLE_ARTICLE_MOUNTED 5


//                                  debug                                     //
should_debug                    = true;


//=-(                     ~~//** CUSTOM VARIABLES **//~~                     )-=//

// Parachute vars
parachute_active = false;
parachute_stats = false;
vis_parachute_angle = 0;
vis_parachute_frame = 0;

grapple_hook_x_origin = 28;
grapple_hook_y_origin = -34;

grapple_hook_state = GRAPPLE_DISABLED;
grapple_hook_x = x;
grapple_hook_y = y;
grapple_hook_hitbox = noone;
grapple_hook_target = noone;
grapple_hook_hsp = 0;
grapple_hook_vsp = 0;
grapple_hook_end_hsp = 0;
grapple_hook_stored_hsp = 0;
grapple_hook_stored_vsp = 0;
grapple_hook_dir = spr_dir;
grapple_hook_timer = 0;

anim_slide_buffer = 0;

ustrong_smear = noone;
dstrong_boom = noone;

dstrong_parried_time = -1;
dstrong_cancel_parry_stun = 0;

taunt_loops = 0;

// Galaxy sfx
hit_last_frame = array_create(noone, 20);
num_hit_last_frame = 0;
stinger_cooldown = 0;


// See also: parachute-labeled stats under "aerial movement stats"

//                           ATTACK/WINDOW INDEXES                            //

/*
- free attack data indexes technically start at 24 up to 99, went with 30 to
make it look cleaner
*/

// adds once-per-air limit to an attack
AG_ATTACK_AIR_LIMIT             = 30;

// might add ai indexes here later so you can tell the cpu when to use certain
// moves

/*
- free window data indexes technically start at 61 up to 99, went with 70 to
make it look cleaner
*/

// adds looping frames to an attack's charge window, while charging
AG_WINDOW_HAS_CHARGE_LOOP       = 70;   // if the window has a charge anim loop
AG_WINDOW_CHARGE_FRAME_START    = 71;   // anim frame of the start of the loop
AG_WINDOW_CHARGE_FRAMES         = 72;   // total number of frames
AG_WINDOW_CHARGE_LOOP_SPEED     = 73;   // speed of the loop animation

AG_WINDOW_GRAB_OPPONENT         = 74;   // if the window is a grab window (1),
                                        // hold opponent, otherwise let them go
AG_WINDOW_GRAB_POS_X            = 75;   // x position to hold grabbed opponent
AG_WINDOW_GRAB_POS_Y            = 76;   // y position to hold grabbed opponent

AG_WINDOW_CAN_WALLJUMP          = 77;   // if the player can walljump out of the
                                        // window



//                               HITBOX INDEXES                               //

/*
- free hitbox data indexes technically start at 54 up to 99, went with 60 to
make it look cleaner
*/

HG_HAS_GRAB                     = 60;   // makes the hitbox into a command grab
HG_BREAKS_GRAB                  = 61;   // if the grabbed player is hit, they're
                                        // no longer grabbed
HG_GRAB_WINDOW_GOTO             = 62;   // window the grab goes into
                                        // -1 if it continues in the same window
HG_GRAB_WINDOWS_NUM             = 63;   // up to what window the grab goes to
                                        // -1 if it doesnt change window num
HG_HAS_LERP                     = 64;   // if the hitbox has lerp properties
HG_LERP_PERCENT                 = 65;   // how much pull the lerp has
                                        // from 0.0~1.0
HG_LERP_POS_X                   = 66;   // x position that the lerp pulls to
HG_LERP_POS_Y                   = 67;   // y position that the lerp pulls to

HG_PROJECTILE_MULTIHIT          = 70;   // if a projectile multihits
HG_PROJECTILE_MULTIHIT_RATE     = 71;   // rate at which a projectile multihits
                                        // ex.: if 10, hits every 10 frames
                                        // (individual per opponent)
HG_PROJECTILE_MAX_HITS          = 72;   // max number of times the projectile
                                        // can hit before being destroyed
                                        // (individual per opponent)
                                        // put -1 for no limit


// if you're making custom indexes for your character, I recommend starting at
// 80 or 90, as slots up to 79 may be filled in future updates

/*
if you're using multihit properties, be sure to check if the projectile goes 
through enemies, otherwise it might just despawn on hit
*/


//=-(                    ~~//** CUSTOM VARIABLES **//~~                    )-=//

//                               PRE-SET STUFF                                //
// attack/hitbox index variables
attack_air_limit                = array_create(50, false);
                                        // tracks per-air limit for attacks
attack_air_limit_ver            = false;// if true, will check if air limits
                                        // should be reset
                                        // so that it doesn't go through the big
                                        // array more often than needed
grabbed_player_obj              = noone;// the player that got grabbed
grabbed_player_relative_x       = 0;    // x position in relation to the player, 
                                        // for the grabbed player to be moved to
grabbed_player_relative_y       = 0;    // y position in relation to the player, 
                                        // for the grabbed player to be moved to

// article variables
article_id                      = noone;// id that refers to a spawned article
                                        // change name to whatever you want

// composite vfx array
comp_vfx_array                  = [[{cur_timer: 1, max_timer: 0}]];
                                        // array containing the composite
                                        // vfx
vfx_created                     = false;// checks if the effect was successfully
                                        // created in the array

/* // WIP 
// alt color shade slots
num_base_colors                 = 1;    // how many colors the character has

col_shade_list                  = [
                                [1],
                                [0],
                                [0],
                                [0],
                                [1],
                                [1]
                                ];      // array holding shade values in each
                                        // alt for each color
                                        // as sandbert only has 1 color and 6
                                        // alts, there's 6 arrays with 1 element

*/
/*
- remember that css needs it's own version of these variables, so if you change
it here, change it there too!
*/

// animation stuff
idle_air_loops                  = false;// whether idle air has a looping 
                                        // animation or not
idle_air_looping                = false;// checks if the loop is happening
jump_frames                     = 5;    // how many animation frames the jump 
                                        // has, the loop starts there
idle_air_loop_speed             = 0.25;  // animation speed of the loop
idle_air_platfalls              = false; // if the character has an animation for
                                        // dropping from platforms
idle_air_platfalling            = false;// checks if platfall is happening
idle_air_platfall_speed         = 0.25; // platfall animation speed
idle_air_platfall_frames        = 7;    // how many frames the platfall anim has
                                        // when finished goes to air idle
dash_moonwalks                  = false; // if the character has a moonwalk anim

//=-(                     ~~//** CUSTOM EFFECTS **//~~                     )-=//

//                           --sound effects--                                //
//a

//                           --visual effects--                               //
// full vfx

fx_ustrong1                     = hit_fx_create(sprite_get("ustrong_vfx1"), 12);
fx_ustrong2                     = hit_fx_create(sprite_get("ustrong_vfx2"), 12);

fx_dstrong                      = hit_fx_create(sprite_get("dstrong_vfx"), 20);
fx_medium_circle1               = hit_fx_create(sprite_get("fx_medium_circle1"),20);

fx_parry_flash                  = hit_fx_create(asset_get("new_dodge_spr"), 26);

hfx_null                        = hit_fx_create(sprite_get("null"), 1);

// NOTE !!!
// while the vfx tool is still a work in progress, I recommend keeping it simple
// and not doing too many effect variants like this, it'll be an absolute hassle 
// to work with otherwise

// plus there's some effects here that I'm gonna remove, and others that need to
// be polished, so you should probs delete those and their sprites and make your
// own

// vfx parts for spawning multiple at a time, for more complex visuals
/*
fx_small_circle1                = hit_fx_create(sprite_get("fx_small_circle1"),14);
fx_small_circle2                = hit_fx_create(sprite_get("fx_small_circle2"),14);
fx_small_circle3                = hit_fx_create(sprite_get("fx_small_circle3"),14);
fx_small_circle4                = hit_fx_create(sprite_get("fx_small_circle4"),14);

fx_small_circle_angled1         = hit_fx_create(sprite_get("fx_small_circle_angled1"),14);

fx_medium_circle1               = hit_fx_create(sprite_get("fx_medium_circle1"),14);

fx_medium_circle_angled1        = hit_fx_create(sprite_get("fx_medium_circle_angled1"),14);
fx_medium_circle_angled2        = hit_fx_create(sprite_get("fx_medium_circle_angled2"),14);

fx_large_circle1                = hit_fx_create(sprite_get("fx_large_circle1"),16);

fx_large_circle_angled1         = hit_fx_create(sprite_get("fx_large_circle_angled1"),16);

fx_small_flare1_0               = hit_fx_create(sprite_get("fx_small_flare1_0"),8);
fx_small_flare1_1               = hit_fx_create(sprite_get("fx_small_flare1_1"),8);
fx_small_flare1_2               = hit_fx_create(sprite_get("fx_small_flare1_2"),8);
fx_small_flare1_3               = hit_fx_create(sprite_get("fx_small_flare1_3"),8);

fx_small_spark1_0               = hit_fx_create(sprite_get("fx_small_spark1_0"),10);
fx_small_spark1_1               = hit_fx_create(sprite_get("fx_small_spark1_1"),10);
fx_small_spark1_2               = hit_fx_create(sprite_get("fx_small_spark1_2"),10);
fx_small_spark1_3               = hit_fx_create(sprite_get("fx_small_spark1_3"),10);

fx_small_centershine            = hit_fx_create(sprite_get("fx_small_centershine"),10);

fx_small_shine0                 = hit_fx_create(sprite_get("fx_small_shine0"),8);
fx_small_shine1                 = hit_fx_create(sprite_get("fx_small_shine1"),8);
fx_small_shine2                 = hit_fx_create(sprite_get("fx_small_shine2"),8);
fx_small_shine3                 = hit_fx_create(sprite_get("fx_small_shine3"),8);

fx_small_flashlight1            = hit_fx_create(sprite_get("fx_small_flashlight1"),14);

// arrays with vfx parts, useful if you want to draw a random one
fx_array_circle_small           = [
                                fx_small_circle1,
                                fx_small_circle2,
                                fx_small_circle3,
                                fx_small_circle4,
                                ];

fx_array_circle_medium          = [
                                fx_medium_circle1
                                ];

fx_array_circle_large           = [
                                fx_large_circle1
                                ];

fx_array_circle_small_angled    = [
                                fx_small_circle_angled1
                                ];

fx_array_circle_medium_angled   = [
                                fx_medium_circle_angled1,
                                fx_medium_circle_angled2,
                                ];

fx_array_circle_large_angled    = [
                                fx_large_circle_angled1
                                ];

fx_array_flare                  = [
                                fx_small_flare1_0,
                                fx_small_flare1_1,
                                fx_small_flare1_2,
                                fx_small_flare1_3
                                ];
                                
fx_array_spark                  = [
                                fx_small_spark1_0,
                                fx_small_spark1_1,
                                fx_small_spark1_2,
                                fx_small_spark1_3
                                ];

fx_array_shine                  = [
                                fx_small_shine0,
                                fx_small_shine1,
                                fx_small_shine2,
                                fx_small_shine3
                                ];

fx_array_flashlight             = [
                                fx_small_flashlight1
                                ];
*/



//=-(                      ~~//** BASE STATS **//~~                        )-=//

//                              --hurtboxes--                                 //
hurtbox_spr                     = asset_get("ex_guy_hurt_box");
crouchbox_spr                   = asset_get("ex_guy_crouch_box");
air_hurtbox_spr                 = -1;
hitstun_hurtbox_spr             = -1;


//                  --animation speeds + %-arrow offset--                     //
char_height                     = 52;
idle_anim_speed                 = 0.1;
crouch_anim_speed               = 0.1;
walk_anim_speed                 = 0.125;
dash_anim_speed                 = 0.3;
pratfall_anim_speed             = 0.25;

//                      --grounded movement stats--                           //
walk_speed                      = 4.25;
walk_accel                      = 0.2;
walk_turn_time                  = 6;
crawl_speed                     = 3;
crawl_accel                     = 0.15;
crawl_turn_time                 = 6;
initial_dash_time               = 8;
initial_dash_speed              = 9;
dash_speed                      = 8.5;
dash_turn_time                  = 6;
dash_turn_accel                 = 1.5;
dash_stop_time                  = 4;
dash_stop_percent               = 0.35;
ground_friction                 = 0.9;
moonwalk_accel                  = 1.4;

//                       --aerial movement stats--                            //
jump_start_time                 = 5;
jump_speed                      = 14;
short_hop_speed                 =7.5;
base_djump_speed                = 14;
parachute_djump_speed           = 9;
djump_speed                     = base_djump_speed;

leave_ground_max                = 7;
max_jump_hsp                    = 8;
air_max_speed                   = 6;
jump_change                     = 3;

base_air_accel                  = 0.2;
parachute_air_accel             = 0.3;
air_accel                       = base_air_accel;
prat_fall_accel                 = 0.85;
air_friction                    = 0.02;

max_djumps                      = 1;
double_jump_time                = 31;

walljump_hsp                    = 7;
walljump_vsp                    = 11;
walljump_time                   = 20;

base_max_fall                   = 13;
base_fast_fall                  = 16;
base_parachute_fall             = 4;
max_fall                        = base_max_fall;
fast_fall                       = base_fast_fall;
gravity_speed                   = 0.7;
base_gravity_speed              = gravity_speed;
parachute_gravity_speed         = 0.3;
hitstun_grav                    = 0.51;


//                    --character knockback adjustment--                      //
/* 
- higher num = 'lighter' character; 
- lower num = 'heavier' character 
*/
knockback_adj                   = 1.15;

//                           --landing stats--                                //
land_time                       = 4; 
prat_land_time                  = 10;
wave_land_time                  = 8;
wave_land_adj                   = 1.35;
wave_friction                   = 0.4;

//                          --animation frames--                              //
crouch_startup_frames           = 3;
crouch_active_frames            = 1;
crouch_recovery_frames          = 2;

// Crouch Animation Start/End Customization by @SupersonicNK
crouch_start_time = 6; // time in frames it takes for crouch start to stop.
crouch_end_time = 6; // time in frames it takes for crouch stop to stop. interruptable.
// Custom Crouch Internal Variables (managed by the code)
ccrouch_playing = false; // whether the custom crouch animation is playing
ccrouch_phase = 0; // 0 = start, 1 = loop, 2 = uncrouch
ccrouch_timer = 0; // timer for the crouch anim
ccrouch_percent = 0; // 0-1, used to calculate what frame to use when rapidly crouching and uncrouching

dodge_startup_frames            = 1;
dodge_active_frames             = 1;
dodge_recovery_frames           = 2;

tech_active_frames              = 1;
tech_recovery_frames            = 1;

techroll_startup_frames         = 2;
techroll_active_frames          = 2;
techroll_recovery_frames        = 2;


air_dodge_startup_frames        = 2;
air_dodge_active_frames         = 2;
air_dodge_recovery_frames       = 3;

roll_forward_startup_frames     = 2;
roll_forward_active_frames      = 2;
roll_forward_recovery_frames    = 2;
roll_back_startup_frames        = 2;
roll_back_active_frames         = 2;
roll_back_recovery_frames       = 2;

//                        --defensive action speed--                          //
techroll_speed                  = 10;

air_dodge_speed                 = 7.5;

roll_forward_max                = 9; 
roll_backward_max               = 9;

//                      --base movement sound effects--                       //
land_sound = asset_get("sfx_land_med");
landing_lag_sound = asset_get("sfx_land");
waveland_sound = asset_get("sfx_waveland_zet");
jump_sound = asset_get("sfx_jumpground");
djump_sound = asset_get("sfx_jumpair");
air_dodge_sound = asset_get("sfx_quick_dodge");
set_victory_bg( sprite_get("perry_victorybg") )
set_victory_portrait( sprite_get("portrait") )
set_victory_theme( sound_get("perry_victory") )

//                       --ranno bubble visual offset--                       //
bubble_x                        = 0;
bubble_y                        = 8;
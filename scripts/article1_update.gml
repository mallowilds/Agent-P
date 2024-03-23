
if (hitstop > 0) exit;
state_timer++;

// Safety: clairen field
if (place_meeting(x, y, asset_get("plasma_field_obj"))) {
	spawn_hit_fx(x, y, (HFX_CLA_DSMASH_BREAK));
	sound_play(asset_get("sfx_clairen_hit_weak"));
	should_die = true;
}

// Safety: blast zones
if (player_id.object_index != oTestPlayer) {
	if (   x < get_stage_data(SD_LEFT_BLASTZONE_X)
		|| x > get_stage_data(SD_RIGHT_BLASTZONE_X)
		|| y > get_stage_data(SD_BOTTOM_BLASTZONE_Y)
	) {
		sound_play(asset_get("sfx_ell_small_missile_ground"));
		should_die = true;
	}

	// Instead of killing off the top, nudge down
	if (y < get_stage_data(SD_TOP_BLASTZONE_Y)+230 && state == 1 && hsp == 0 && vsp == 0) {
		y += 4;
	}
}

// HUD offset
if (is_primed) hud_offset = primed_hud_offset


switch(state) { // use this one for doing actual article behavior

    case 0: // spawn
    
        if (state_timer == 1) {
            hsp = (throw_dir == -1) ? 2 : 4 + (2 * throw_dir);
            hsp *= spr_dir;
            vsp = -6.5 + (3 * throw_dir);
            
            hbox = create_hitbox(AT_NSPECIAL, 1, x, y);
            hbox.agent_p_grapple_hitbox = true;
            hbox.owner_drone = self
        }
        
        if (hit_wall) {
            spr_dir *= -1;
            hsp = (throw_dir == -1) ? 2 : 4 + (2 * throw_dir);
            hsp *= spr_dir;
        }
        
        if (vsp < 6) vsp += 0.2;
        
        hit_detection();
        
        if (state_timer == 23) sound_play(asset_get("sfx_ell_dspecial_drop"));
        if (state_timer == 25) {
            //var vfx = spawn_hit_fx(x, y, HFX_ELL_STEAM_HIT);
            //vfx.depth = depth+1;
            set_state(1);
            enemy_hittable = false;
            if (instance_exists(hbox)) hbox.destroyed = true;
        }
        
        else if (state != 3 && instance_exists(hbox)) {
            hbox.x = x;
            hbox.y = y;
            hbox.hsp = hsp;
            hbox.vsp = vsp;
            hbox.length++;
        }
        break;
        
    case 1: // idle
        if (vsp < 6) vsp += 0.1
        do_air_friction(0.3);
        if (state_timer + lifetime_decayed >= max_lifetime && !agent_p_grappling) set_state(2);
        hit_detection();
        break;
        
    case 2: // naturally despawn
        should_die = true;
        var despawn_obj = instance_create(floor(x), floor(y), "obj_article3");
        despawn_obj.state = 02;
        despawn_obj.vis_frame = image_index;
        despawn_obj.vis_alpha = 1;
        despawn_obj.is_primed = is_primed;
        break;
    
    case 3: // hit -> explode
    
        if (state_timer == 1) {
            hsp = lengthdir_x(8, kb_dir);
            vsp = lengthdir_y(8, kb_dir);
        }
        else do_air_friction(0.2);
        
        hit_detection();
        
        vis_frame = 4 + (state_timer / 4) % 12;
        if (state_timer > 15) {
        	if (has_rune("H")) create_hitbox(AT_NSPECIAL, 3, x, y); // explosion rune
            sound_play(asset_get("sfx_ell_small_missile_ground"));
            spawn_hit_fx(x, y, HFX_ELL_FSPEC_BREAK);
            should_die = true;
        }
        break;
        
}


sprite_index = sprite_get("drone" + (is_primed ? "_primed" : "") + (is_ea ? "_ea" : ""));
switch(state) { // use this one for changing sprites and animating
    case 0: // spawn
        image_index = (state_timer / 4) % 4;
        break;
    case 1: // idle
        if (agent_p_grappling && agent_p_grapple_dir != 0) { // grappled
            if (agent_p_grapple_dir < 0) image_index = 16 + (state_timer / 5) % 2;
            else image_index = 14 + (state_timer / 5) % 2;
        }
        else if (state_timer < 4) image_index = 4 + (state_timer / 2); // startup
        else image_index = 6 + (state_timer / 5) % 8; // loop
        break;
    case 3: // exploding
        if (hsp*spr_dir < 0) image_index = 16 + (state_timer / 5) % 2;
        else image_index = 14 + (state_timer / 5) % 2;
        break;
}
// don't forget that articles aren't affected by small_sprites

mask_index = asset_get("drone_mask");

if (should_die) { //despawn and exit script
    player_id.nspec_num_drones--;
    instance_destroy();
    exit;
}

// Reset grappling var
agent_p_grappling = 0;


#define set_state
var _state = argument0;
state = _state;
state_timer = 0;

#define do_air_friction(decel)
    var dec_dir = point_direction(hsp, vsp, 0, 0);
    var hsp_dec = lengthdir_x(decel, dec_dir);
    var vsp_dec = lengthdir_y(decel, dec_dir);
    
    hsp = (abs(hsp_dec) < abs(hsp)) ? (hsp + hsp_dec) : 0;
    vsp = (abs(vsp_dec) < abs(vsp)) ? (vsp + vsp_dec) : 0;

    

// Supersonic Hit Detection Template

#define on_hit(hbox)
// This is the code the article should run on hit.
// Edit this to have the desired functions when your article is hit by a hitbox.
// hbox refers to the pHitBox object that hit the article.
// hit_player_obj (usually) refers to the player that hit the article.
// hit_player_num refers to the player's number that hit the article.
 
hit_player_obj = hbox.player_id;
hit_player_num = hbox.player;

//State management
if (state != 3) state = 3;
state_timer = 0;

//Default Hitpause Calculation
//You probably want this stuff because it makes the hit feel good.
if hbox.type == 1 {
    var desired_hitstop = clamp(hbox.hitpause + hbox.damage * hbox.hitpause_growth * 0.05, 0, 20);
    with hit_player_obj {
        if !hitpause {
            old_vsp = vsp;
            old_hsp = hsp;
        }
        hitpause = true;
        has_hit = true;
        if hitstop < desired_hitstop {
            hitstop = desired_hitstop;
            hitstop_full = desired_hitstop;
        }
    }
}

// SK compat
if (hbox.player_id.url == CH_SHOVEL_KNIGHT && hbox.attack == AT_DAIR && hbox.type == 1) {
    if (hbox.player_id.vsp > -5) hbox.player_id.vsp = -5;
    if (hbox.player_id.old_vsp > -5) hbox.player_id.old_vsp = -5;
    if (hbox.hbox_num == 3) sound_play(asset_get("sfx_shovel_hit_light1")); // idk why this one doesn't have sfx lol
}


hitstop = floor(desired_hitstop); 

if article_should_lockout hit_lockout = hbox.no_other_hit;

kb_dir = get_hitbox_angle(hbox);
 
//Default hit stuff
sound_play(hbox.sound_effect);
//ty nart :p
var fx_x = lerp(hbox.x, x, 0.5) + hbox.hit_effect_x*hbox.spr_dir;
var fx_y = lerp(hbox.y, y, 0.5) + hbox.hit_effect_y;
with hit_player_obj { // use a with so that it's shaded correctly
    var temp_fx = spawn_hit_fx(fx_x, fx_y, hbox.hit_effect);
    temp_fx.hit_angle = other.kb_dir;
    temp_fx.kb_speed = other.orig_knock;
}
 
#define filters(hbox)
//These are the filters that check whether a hitbox should be able to hit the article.
//Feel free to tweak this as necessary.
with hbox {
    var player_equal = player == other.player_id.player;
    var team_equal = get_player_team(player) == get_player_team(other.player_id.player);
    return ("owner" not in self || owner != other) //check if the hitbox was created by this article
        && hit_priority != 0 && hit_priority <= 10
        && (groundedness == 0 || groundedness == 1+other.free)
        && "agent_p_grapple_hitbox" not in self
        && (player_equal || other.enemy_hittable)
        //&& ( (get_match_setting(SET_TEAMS) && (get_match_setting(SET_TEAMATTACK) || !team_equal) ) || player_equal) //uncomment to prevent the article from being hit by its owner's team.
}
 
#define hit_detection
//Code by Supersonic#9999
//DO NOT modify this function unless you know what you're doing. This does the actual detection, while
//the other functions determine how and what the hit detection interacts with.
//hbox group management
with (oPlayer)
    if state == clamp(state, 5, 6) && window == 1 && window_timer == 1 {
        other.hbox_group[@ player-1][@ attack] = array_create(10,0);
    }
 
//hit lockout stuff
if hit_lockout > 0 {
    hit_lockout--;
    return;
}
//get colliding hitboxes
var hitbox_list = ds_list_create();
 
var num = instance_place_list(floor(x), floor(y), pHitBox, hitbox_list, false);
var final_hbox = noone;
var hit_variable = `hit_article_${id}`;
if num == 0 {
    ds_list_destroy(hitbox_list);
    return;
}
if num == 1 {
    //no priority checks if only one hitbox is found
    var hbox = hitbox_list[|0]
    var group = hbox.hbox_group
    if hit_variable not in hbox 
        if (group == -1 || ( group != -1 && hbox_group[@ hbox.orig_player-1][@ hbox.attack][@ group] == 0)) {
            if filters(hbox) {
                final_hbox = hbox;
            } else {
                //hitbox doesn't meet collision criteria. since this usually doesn't change, omit it.
                variable_instance_set(hbox, hit_variable, true);
            }
        } else {
            //fake hit if group has already hit; optimization thing
            variable_instance_set(hbox, hit_variable, true);
        }
} else {
    var highest_priority = 0;
    var highest_priority_owner = -1;
    var highest_priority_hbox = noone;
    for (var i = 0; i < ds_list_size(hitbox_list); i++) {
        var hbox = hitbox_list[|i]
        var group = hbox.hbox_group
        if hit_variable not in hbox 
            //group check
            if (group == -1 || ( group != -1 && hbox_group[@ hbox.orig_player-1][@ hbox.attack][@ group] == 0)) {
                if filters(hbox) {
                    if hbox.hit_priority > highest_priority {
                        highest_priority = hbox.hit_priority;
                        highest_priority_owner = hbox.player;
                        highest_priority_hbox = hbox;
                    }
                } else {
                    //hitbox doesn't meet collision criteria. since this usually doesn't change, omit it.
                    variable_instance_set(hbox, hit_variable, true);
                }
            } else {
                //fake hit if group has already hit; optimization thing
                variable_instance_set(hbox, hit_variable, true);
            }
    }
    if highest_priority != 0 {
        final_hbox = highest_priority_hbox;
    }
}
 
if final_hbox != noone {
    on_hit(final_hbox);
    variable_instance_set(final_hbox, hit_variable, true);
    if final_hbox.hbox_group != -1 hbox_group[@ final_hbox.orig_player-1][@ final_hbox.attack][@ final_hbox.hbox_group] = 1;
}
 
//clear hitbox list
//ds_list_clear(hitbox_list)
ds_list_destroy(hitbox_list);
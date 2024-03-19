
#macro GRAPPLE_DISABLED 0
#macro GRAPPLE_ACTIVE 1
#macro GRAPPLE_RETURNING 2
#macro GRAPPLE_PLAYER_MOUNTED 3
#macro GRAPPLE_WALL_MOUNTED 4
#macro GRAPPLE_ARTICLE_MOUNTED 5

//intro
if get_gameplay_time() == 2 {
	if freemd == 1 {
		set_state(PS_ATTACK_GROUND)
		attack = AT_INTRO_1
	} else {
		set_state(PS_ATTACK_GROUND)
		attack = AT_INTRO_2
	}
}


// Respawn platform
var is_on_plat = (state == PS_RESPAWN || (state == PS_ATTACK_GROUND && respawn_taunt > 0));
if (is_on_plat) plat_active = 1;

else if (!is_on_plat && plat_active) {
	plat_active = false;
	var despawn_plat = instance_create(x, y, "obj_article3");
	despawn_plat.state = 01;
	despawn_plat.vis_alpha = 1;
}

// Parachute

if (parachute_active) {
	
	if (free) attack_air_limit[AT_USPECIAL] = true;
	
	var jump_out_of_grapple = (((state == PS_JUMPSQUAT && prev_state == PS_ATTACK_GROUND) || state == PS_FIRST_JUMP) && attack == AT_FSPECIAL);
	
	// Also reset in got_hit, got_parried, and death.gml
	if ((!free && grapple_hook_state < GRAPPLE_PLAYER_MOUNTED && !jump_out_of_grapple) || state == PS_AIR_DODGE || state == PS_WALL_JUMP) {
		parachute_active = false;
		var despawn_parachute = instance_create(x+(1*spr_dir), y-15, "obj_article3");
		despawn_parachute.state = 00;
	}
	if (fast_falling) {
		if (down_down) {
			if (vis_parachute_frame >= 1) vis_parachute_frame -= 0.34;
		} else {
			fast_falling = false;
			if (vsp > base_parachute_fall) vsp = base_parachute_fall;
		}
	}
	else {
		if (vis_parachute_frame < 2) vis_parachute_frame += 0.34;
	}
	
	if (!parachute_stats) {
		parachute_stats = true;
		
		max_fall = base_parachute_fall;
		fast_fall = base_max_fall;
		gravity_speed = parachute_gravity_speed;
		jump_speed = parachute_jump_speed;
		short_hop_speed = parachute_sh_speed;
		djump_speed = parachute_djump_speed;
		air_accel = parachute_air_accel;
		
	}
	
	if (!hitpause) vis_parachute_angle = lerp(vis_parachute_angle, hsp * 40 / air_max_speed, 0.2);
	
}
else {
	
	if (!free) attack_air_limit[AT_USPECIAL] = false;
	
	if (parachute_stats) {
		parachute_stats = false;
		
		max_fall = base_max_fall;
		fast_fall = base_fast_fall;
		gravity_speed = base_gravity_speed;
		jump_speed = base_jump_speed;
		short_hop_speed = base_sh_speed;
		djump_speed = base_djump_speed;
		air_accel = base_air_accel;
	}
	
}


// NSpec cooldown management
if (nspec_drone_cd > nspec_num_drones * nspec_drone_cd_max) nspec_drone_cd--;



//#region Grapple handling
switch grapple_hook_state {
	
	case GRAPPLE_ACTIVE:
		grapple_hook_hsp -= (grapple_hook_timer / 12) * grapple_hook_dir;
		grapple_hook_vsp = vsp; // approximately accurate lol
    	
    	grapple_hook_x += grapple_hook_hsp;
		grapple_hook_y += grapple_hook_vsp;
		
		var collided_article = noone;
		var article_collision_list = ds_list_create();
		
		// non-solid base cast articles (so, just ranno)
		collided_article = instance_position(floor(grapple_hook_x), floor(grapple_hook_y), asset_get("frog_bubble_obj"));
		
		// ws articles
		if (collided_article == noone) {
			instance_position_list(floor(grapple_hook_x), floor(grapple_hook_y), asset_get("obj_article_parent"), article_collision_list, false);
			for (var i = 0; i < ds_list_size(article_collision_list); i++) {
				if (instance_exists(article_collision_list[| i]) && "agent_p_grapplable" in article_collision_list[| i]) {
					collided_article = article_collision_list[| i];
					break;
				}
			}
		}
		
		var collided_wall = instance_position(floor(grapple_hook_x), floor(grapple_hook_y), asset_get("par_block"));
		if (collided_wall == noone) collided_wall = instance_position(floor(grapple_hook_x), floor(grapple_hook_y), asset_get("par_jumpthrough"));
		
		if (position_meeting(grapple_hook_x, grapple_hook_y, asset_get("plasma_field_obj"))) {
			grapple_hook_hitbox = noone;
			grapple_hook_state = GRAPPLE_RETURNING;
    		grapple_hook_timer = 0;
    		
    		spawn_hit_fx(grapple_hook_x, grapple_hook_y, (HFX_CLA_DSMASH_BREAK));
    		sound_play(asset_get("sfx_clairen_hit_weak"));
		}
		
		else if (!was_parried && collided_wall != noone) {
			
			grapple_hook_state = GRAPPLE_WALL_MOUNTED;
    		grapple_hook_timer = 0;
    		stored_hsp = hsp;
    		stored_vsp = vsp;
    		if (instance_exists(grapple_hook_hitbox)) {
    			grapple_hook_hitbox.destroyed = true;
    			grapple_hook_hitbox = noone;
    		}
    		grapple_hook_hsp = 0;
    		grapple_hook_vsp = 0;
    		
    		grapple_hook_target = collided_wall;
			grapple_hook_target_x_offset = (grapple_hook_x - get_instance_x(grapple_hook_target));
			grapple_hook_target_y_offset = (grapple_hook_y - get_instance_y(grapple_hook_target));
		}
		
		else if (!was_parried && collided_article != noone) {
			grapple_hook_state = GRAPPLE_ARTICLE_MOUNTED;
    		grapple_hook_timer = 0;
    		stored_hsp = hsp;
    		stored_vsp = vsp;
    		if (instance_exists(grapple_hook_hitbox)) {
    			grapple_hook_hitbox.destroyed = true;
    			grapple_hook_hitbox = noone;
    		}
    		grapple_hook_hsp = 0;
    		grapple_hook_vsp = 0;
    		
    		grapple_hook_target = collided_article;
			grapple_hook_target_x_offset = (grapple_hook_x - get_instance_x(grapple_hook_target));
			grapple_hook_target_y_offset = (grapple_hook_y - get_instance_y(grapple_hook_target));
		}
		
		else if (!was_parried && !instance_exists(grapple_hook_hitbox) && !grapple_hook_hboxless) {
			grapple_hook_hitbox = noone;
			grapple_hook_state = GRAPPLE_RETURNING;
    		grapple_hook_timer = 0;
    	}
    	
    	else if (grapple_hook_hsp * grapple_hook_dir <= grapple_hook_end_hsp * grapple_hook_dir) {
    		if (instance_exists(grapple_hook_hitbox)) {
    			grapple_hook_hitbox.destroyed = true;
    			grapple_hook_hitbox = noone;
    		}
    		grapple_hook_state = GRAPPLE_RETURNING;
    		grapple_hook_timer = 0;
		}
		
		else if (!was_parried && !grapple_hook_hboxless) {
			grapple_hook_hitbox.hsp = grapple_hook_hsp;
			grapple_hook_hitbox.vsp = grapple_hook_vsp;
			
			// safety check for grappleable base cast articles
			if (   centered_rect_meeting(floor(grapple_hook_x+grapple_hook_hsp), floor(grapple_hook_y+grapple_hook_vsp+gravity_speed), 12, 28, asset_get("pillar_obj"), false)
				|| centered_rect_meeting(floor(grapple_hook_x+grapple_hook_hsp), floor(grapple_hook_y+grapple_hook_vsp+gravity_speed), 12, 28, asset_get("rock_obj"), false)
				|| centered_rect_meeting(floor(grapple_hook_x+grapple_hook_hsp), floor(grapple_hook_y+grapple_hook_vsp+gravity_speed), 12, 28, asset_get("frog_bubble_obj"), true)
			) {
				grapple_hook_hitbox.destroyed = true;
    			grapple_hook_hitbox = noone;
    			grapple_hook_hboxless = true;
			}
		}
		
		ds_list_destroy(article_collision_list);
		
    	break;
    	
	case GRAPPLE_RETURNING:
		var gh_angle = point_direction(grapple_hook_x, grapple_hook_y, x + (grapple_hook_x_origin+grapple_hook_x_offset)*spr_dir, y + grapple_hook_y_origin+grapple_hook_y_offset);
		var gh_speed = min(grapple_hook_timer / 1.5, point_distance(grapple_hook_x, grapple_hook_y, x + (grapple_hook_x_origin+grapple_hook_x_offset)*spr_dir, y + grapple_hook_y_origin+grapple_hook_y_offset));
		grapple_hook_hsp = lengthdir_x(gh_speed, gh_angle);
		grapple_hook_vsp = lengthdir_y(gh_speed, gh_angle);
		
		grapple_hook_x += grapple_hook_hsp;
		grapple_hook_y += grapple_hook_vsp;
		
		if (point_distance(grapple_hook_x, grapple_hook_y, x + (grapple_hook_x_origin+grapple_hook_x_offset)*spr_dir, y + grapple_hook_y_origin+grapple_hook_y_offset) < 0.1) {
			grapple_hook_state = GRAPPLE_DISABLED;
			grapple_hook_timer = 0;
		}
		break;
	
	case GRAPPLE_PLAYER_MOUNTED:
		
		grapple_hook_x = grapple_hook_target.x + grapple_hook_target_x_offset;
		grapple_hook_y = grapple_hook_target.y + grapple_hook_target_y_offset;
		
		var mov_angle = point_direction(x + (grapple_hook_x_origin * spr_dir), y + grapple_hook_y_origin, grapple_hook_x, grapple_hook_y);
		var mov_accel = 0.6;
		
		// error state: not in fspecial
		if  ((state != PS_ATTACK_AIR && state != PS_ATTACK_GROUND) || attack != AT_FSPECIAL) {
			grapple_hook_state = GRAPPLE_DISABLED;
			grapple_hook_timer = 0;
			grapple_hook_target = noone;
			break;
		}
		
		// error state: unlinked
		if (!instance_exists(grapple_hook_target) || grapple_hook_target.state_cat != SC_HITSTUN) {
			if (vsp > -4) vsp = -4;
			set_state(PS_IDLE_AIR);
			attack_end();
			grapple_hook_state = GRAPPLE_DISABLED;
			grapple_hook_timer = 0;
			grapple_hook_target = noone;
			break;
		}
		
		// error state: unmoving
		if (grapple_hook_timer > 6 && abs(point_distance(0, 0, hsp, vsp)) < 2*mov_accel) {
			// Simply proceeding to the attack followup seems to feel best for now. May revisit
			grapple_hook_state = GRAPPLE_DISABLED;
			grapple_hook_timer = 0;
			grapple_hook_target = noone;
			break;
		}
		
		grapple_hook_target.hitstop++;
		
		hsp = hsp + lengthdir_x(mov_accel, mov_angle);
		vsp = vsp + lengthdir_y(mov_accel, mov_angle);
		
		if (abs(grapple_hook_x - x - (grapple_hook_x_origin * spr_dir)) < abs(hsp)) {
			grapple_hook_state = GRAPPLE_DISABLED;
			grapple_hook_timer = 0;
			grapple_hook_target = noone;
		}
		
		else {
			wall_snap(spr_dir, 40, hsp); // predict for next step
		}
		
		break;
	
	case GRAPPLE_WALL_MOUNTED:
	case GRAPPLE_ARTICLE_MOUNTED:
	
		// error state: unlinked
		if (!instance_exists(grapple_hook_target)) {
			if (vsp > -4) vsp = -4;
			if (attack == AT_FSPECIAL && (state == PS_ATTACK_GROUND || state == PS_ATTACK_AIR)) {
				set_state(PS_IDLE_AIR);
				attack_end();
				grapple_hook_state = GRAPPLE_DISABLED;
				grapple_hook_timer = 0;
				grapple_hook_target = noone;
				break;
			}
		}
		
		grapple_hook_x = get_instance_x(grapple_hook_target) + grapple_hook_target_x_offset;
		grapple_hook_y = get_instance_y(grapple_hook_target) + grapple_hook_target_y_offset;
		
		var mov_angle = point_direction(x, y + grapple_hook_y_origin, grapple_hook_x, grapple_hook_y);
		var mov_accel = 0.6;
		
		if (!free  && (mov_angle < 0 || 180 < mov_angle)) {
			var ldx = lengthdir_x(mov_accel, mov_angle);
			var hsp_dir = hsp / abs(hsp);
			var hsp_change = mov_accel * hsp_dir * sqrt(abs(2*ldx/mov_accel - (ldx*ldx/mov_accel/mov_accel)));
			// above transformation: https://www.desmos.com/calculator/qhpjd7mgxu
			stored_hsp = hsp + hsp_change;
			if (!use_stored_vsp) { // begin storing vsp
				stored_vsp = vsp + lengthdir_y(mov_accel, mov_angle);
				use_stored_vsp = true;
			}
			else stored_vsp = stored_vsp + lengthdir_y(mov_accel, mov_angle);
		}
		else {
			stored_hsp = hsp + lengthdir_x(mov_accel, mov_angle);
			stored_vsp = vsp + lengthdir_y(mov_accel, mov_angle);
			use_stored_vsp = false;
		}
		
	
		if (   (state != PS_ATTACK_GROUND && state != PS_ATTACK_AIR)
			|| (attack != AT_FSPECIAL)
			|| (point_distance(grapple_hook_x, grapple_hook_y, x, y + grapple_hook_y_origin) < point_distance(0, 0, stored_hsp, stored_vsp))
			|| (point_distance(0, 0, stored_hsp, stored_vsp) < grapple_hook_timer * 0.12 && grapple_hook_timer > 15)
		) {
			grapple_hook_state = GRAPPLE_DISABLED;
			grapple_hook_timer = 0;
		}
		
		else {
			hsp = stored_hsp;
			if (free || stored_vsp < -0.5) vsp = stored_vsp; // ensure stored vsp is sufficient to counter gravity
		}
		
		// safe zone (walls and base cast articles won't run this)
		if ("agent_p_grapplable" in grapple_hook_target) {
			
			grapple_hook_target.agent_p_grappling = 1;
			
			if (grapple_hook_target.agent_p_pull_vel != 0) {
				grapple_hook_target.x -= lengthdir_x(grapple_hook_target.agent_p_pull_vel, mov_angle);
				grapple_hook_target.y -= lengthdir_y(grapple_hook_target.agent_p_pull_vel, mov_angle);
				
				grapple_hook_x = grapple_hook_target.x + grapple_hook_target_x_offset;
				grapple_hook_y = grapple_hook_target.y + grapple_hook_target_y_offset;
			}
			
			// While in this safe zone, apply the lifetime penalty to perry drones
			if (grapple_hook_target.agent_p_grapplable == 2 && grapple_hook_target.last_decay_frame != get_gameplay_time()) {
				grapple_hook_target.last_decay_frame = get_gameplay_time()
				grapple_hook_target.lifetime_decayed += grapple_hook_target.lifetime_decay_step;
			}
			
		}
		
		break;
	
}
grapple_hook_timer++;

//#endregion


// Galaxy stinger SFX
for (var i = 0; i < num_hit_last_frame; i++) {
	if (hit_last_frame[i].activated_kill_effect && hit_last_frame[i].should_make_shockwave && stinger_cooldown == 0) {
		if (attack == AT_DTILT || attack == AT_DSTRONG || random_func(0, 1, false) < 0.7) {
			sound_play(sound_get("sfx_perry_stinger"), 0, 0, 1.5);
			stinger_cooldown = 110;
		} else {
			sound_play(sound_get("sfx_perry_stinger_2"), 0, 0, 1.3);
			stinger_cooldown = 130;
		}
	}
	hit_last_frame[i] = noone;
}
num_hit_last_frame = 0;
if (stinger_cooldown > 0) {
	stinger_cooldown--;
	if stinger_cooldown > 20 {
		suppress_stage_music( .2, 1)
	} else {
		suppress_stage_music( 1, .1)
	}
}


if state == PS_WAVELAND && state_timer == 1 && !hitpause {
    sound_play(asset_get("sfx_waveland_hod"), 0, noone, .8, 1.1)
}
if state == PS_DOUBLE_JUMP && (state_timer == 1 || state_timer == 8 || state_timer == 16) && !hitpause {
    sound_play(asset_get("sfx_swipe_weak1"), 0, noone, .5, 1.2)
}
if state == PS_FIRST_JUMP &&  state_timer == 0 && !hitpause {
    sound_play(asset_get("sfx_swipe_weak1"), 0, noone, .5, 1)
}

// reset idle_air_looping if the character isn't in air idle anymore
if (!(state == PS_FIRST_JUMP || state == PS_IDLE_AIR)) {
	idle_air_looping = false;
	idle_air_platfalling = false;
}

// remove attack air limit once character lands, respawns, walljumps or is hit
if (attack_air_limit_ver) {
	if ((!free || state == PS_RESPAWN || state == PS_WALL_JUMP || state == PS_HITSTUN) && state_timer == 1) {
		for(var i=0;i<array_length(attack_air_limit);i++) {
			attack_air_limit[i] = false;
		}
		attack_air_limit_ver = false;
	}
}

// character recoloring / applying shade values
// init_shader(); //unused for now
// composite vfx update
update_comp_hit_fx();

#define wall_snap(dir, max_height, x_offset)

	if (max_height > char_height) {
		print_debug("ERROR: bad max_height for wall_snap()");
		return false;
	}
	
	if (wall_snap_collision(dir, max_height, x_offset)) {
		
		var snap_height = max_height / 2;
		var itr = floor(log2(max_height)); // approx. pixel-level accuracy
		
		for (var p = 2; p < itr + 2; p++) { // binary search
			
			if (wall_snap_collision(dir, snap_height, x_offset)) {
				snap_height -= (max_height / (power(2, p)));
			} else {
				snap_height += (max_height / (power(2, p)));
			}
			
			//print_debug(snap_height);
			
		}
		
		y -= snap_height;
		return true;
		
	}
	
	return false;
	
#define wall_snap_collision(dir, max_height, x_offset)
	var l_bound = 20 * dir + x_offset;
	var r_bound = 24 * dir + x_offset;
	
	return collision_rectangle(x+l_bound, y-1, x+r_bound, y-max_height, asset_get("par_block"), false, false)
		 && !collision_rectangle(x+l_bound, y-max_height, x+r_bound, y-char_height, asset_get("par_block"), false, false);

#define centered_rect_meeting(_x, _y, _w, _h, obj, prec)
    return collision_rectangle(_x-(_w/2), _y-(_h/2), _x+(_w/2), _y+(_h/2), obj, prec, false);

#define update_comp_hit_fx
//function updates comp_vfx_array
if comp_vfx_array != null {
    for(var ao=0;ao<array_length(comp_vfx_array);ao++) {
        if (comp_vfx_array[ao][0].cur_timer > comp_vfx_array[ao][0].max_timer) { //if effect is over, skip
            continue;
        }//otherwise go on
        comp_vfx_array[ao][0].cur_timer += 1; //update effect timer
        var check_timer = comp_vfx_array[ao][0].cur_timer; //store in a var for easier access
        for (var ae=1; ae<array_length(comp_vfx_array[ao]);ae++) { //check effect timers
            if (check_timer == comp_vfx_array[ao][ae].delay_timer) { //if timer is the spawn time, spawn it
                var new_fx = spawn_hit_fx(comp_vfx_array[ao][ae].x,comp_vfx_array[ao][ae].y,comp_vfx_array[ao][ae].index);
                new_fx.draw_angle = comp_vfx_array[ao][ae].rotation;
                new_fx.depth = depth+1+comp_vfx_array[ao][ae].depth; //so it appears in front of hit players
                new_fx.spr_dir = comp_vfx_array[ao][ae].spr_dir; // set it's spr dir, in case it should face a specific direction
            }
        }
    }
}

#define spawn_comp_hit_fx
//function takes in an array that contains smaller arrays with the vfx information
// list formatting: [ [x, y, delay_time, index, rotation, depth, force_dir], ..]
var fx_list = argument0;
vfx_created = false;

//temporary array
var temp_array = [{cur_timer: -1, max_timer: 0}];  //first value is an array that constains current and max timer, to detect when to spawn vfx and when to stop and be replaced
                            //later values are the fx
var player_dir = spr_dir;

//first take the arrays from the function, set them into objects, and store them in an array
for (var i=0;i < array_length(fx_list);i++) {
    //create new fx part tracker and add to temp array
    var new_fx_part = {
        x: fx_list[i][0],
        y: fx_list[i][1],
        delay_timer: fx_list[i][2],
        index: fx_list[i][3],
        rotation: fx_list[i][4],
        depth: fx_list[i][5],
        spr_dir: fx_list[i][6] == 0 ? player_dir : fx_list[i][6]
    };
    array_push(temp_array, new_fx_part);
    
    //change max timer if delay is bigger than it
    if (new_fx_part.delay_timer > temp_array[0].max_timer) {
        temp_array[0].max_timer = new_fx_part.delay_timer;
    }
}

//add temp array to final array
for (var e=0;e<array_length(comp_vfx_array);e++) {
    if (vfx_created) { //stop process if effect is created
        break;
    } 
    if (comp_vfx_array[e][0].cur_timer > comp_vfx_array[e][0].max_timer) { //replace finished effects
        comp_vfx_array[e] = temp_array;
        vfx_created = true;
    } else if (e == array_length(comp_vfx_array)-1) { //otherwise add it in the end of the array
        array_push(comp_vfx_array, temp_array);
        vfx_created = true;
    }
}

#define spawn_base_dust // written by supersonic
/// spawn_base_dust(x, y, name, dir = 0)
var dlen; //dust_length value
var dfx; //dust_fx value
var dfg; //fg_sprite value
var dfa = 0; //draw_angle value
var dust_color = 0;
var x = argument[0], y = argument[1], name = argument[2];
var dir = argument_count > 3 ? argument[3] : 0;

switch (name) {
	default: 
	case "dash_start":dlen = 21; dfx = 3; dfg = 2626; break;
	case "dash": dlen = 16; dfx = 4; dfg = 2656; break;
	case "jump": dlen = 12; dfx = 11; dfg = 2646; break;
	case "doublejump": 
	case "djump": dlen = 21; dfx = 2; dfg = 2624; break;
	case "walk": dlen = 12; dfx = 5; dfg = 2628; break;
	case "land": dlen = 24; dfx = 0; dfg = 2620; break;
	case "walljump": dlen = 24; dfx = 0; dfg = 2629; dfa = dir != 0 ? -90*dir : -90*spr_dir; break;
	case "n_wavedash": dlen = 24; dfx = 0; dfg = 2620; dust_color = 1; break;
	case "wavedash": dlen = 16; dfx = 4; dfg = 2656; dust_color = 1; break;
}
var newdust = spawn_dust_fx(x,y,asset_get("empty_sprite"),dlen);
if newdust == noone return noone;
newdust.dust_fx = dfx; //set the fx id
if dfg != -1 newdust.fg_sprite = dfg; //set the foreground sprite
newdust.dust_color = dust_color; //set the dust color
if dir != 0 newdust.spr_dir = dir; //set the spr_dir
newdust.draw_angle = dfa;
return newdust;
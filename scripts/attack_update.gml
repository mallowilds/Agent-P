
#macro GRAPPLE_DISABLED 0
#macro GRAPPLE_ACTIVE 1
#macro GRAPPLE_RETURNING 2
#macro GRAPPLE_PLAYER_MOUNTED 3
#macro GRAPPLE_WALL_MOUNTED 4
#macro GRAPPLE_ARTICLE_MOUNTED 5


// B Reverse for the specials
if (attack == AT_NSPECIAL || attack == AT_FSPECIAL || attack == AT_DSPECIAL || attack == AT_USPECIAL){
    trigger_b_reverse();
}
// window length of the current window of the attack
var window_length = get_window_value(attack, window, AG_WINDOW_LENGTH);

// specific attack behaviour
switch(attack) {
    case AT_JAB:
        // clear attack so jab2 doesn't automatically happen
    	if (window == 1 && window_timer == 1) { // WARN: Possible repetition during hitpause. Consider using window_time_is(frame) https://rivalslib.com/assistant/function_library/attacks/window_time_is.html
    		clear_button_buffer(PC_ATTACK_PRESSED);
    	}
        break;
    case AT_FTILT:
        //a
        break;
    case AT_DTILT:
        if window_timer == 12 && window == 1 && !hitpause {
            sound_play(asset_get("sfx_bite"))
        }
        down_down = true 
        break;
    case AT_UTILT:
        //a
        break;
    case AT_DATTACK:
        break;
        
    case AT_NAIR:
        //a
        break;
    case AT_FAIR:
        //a
        break;
    case AT_BAIR:
        //a
        break;
    case AT_DAIR:
        if window_timer == 7 && !hitpause && window == 1 {
            sound_play(asset_get("sfx_ori_stomp_spin"))
        }
        //a
        break;
    case AT_UAIR:
        //a
        break;
    
    case AT_NSPECIAL:
        
        if (window == 1 && window_timer == get_window_value(attack, window, AG_WINDOW_LENGTH)) {
        	var nspec_drone = instance_create(floor(x)+(40*spr_dir), floor(y)-40, "obj_article1");
        	nspec_drone.throw_dir = clamp(down_down + down_stick_down - up_down - up_stick_down, -1, 1);
        	
        	nspec_num_drones++;
        	nspec_drone_cd += nspec_drone_cd_max;
        	
        	if (free) vsp = (parachute_active ? -6 : -8);
        }
        
        break;
    case AT_FSPECIAL:
    
    	if (window < 4) {
    		can_fast_fall = false;
    		if (vsp > 2.5) vsp = 2.5;
		    if (hsp > 0.5) hsp = lerp(hsp, 0.5, 0.1);
		    if (hsp < -0.5) hsp = lerp(hsp, -0.5, 0.1);
    	}
    	
    	switch window {
    		case 1:
    			if (window_timer == 1 && vsp > 0) vsp = 0;
    			break;
    		
    		case 2:
    			if (window_timer == 1) {
    				grapple_hook_state = GRAPPLE_ACTIVE;
	        		grapple_hook_timer = 0;
	        		grapple_hook_x = x + (grapple_hook_x_origin * spr_dir) + (grapple_hook_x_offset * spr_dir);
	        		grapple_hook_y = y + grapple_hook_y_origin + grapple_hook_y_offset;
	        		grapple_hook_dir = spr_dir;
	        		grapple_hook_hsp = 20 * spr_dir;
	        		grapple_hook_end_hsp = hsp;
	        		grapple_hook_vsp = vsp;
	        		
	        		grapple_hook_hboxless = false;
	        		grapple_hook_hitbox = create_hitbox(AT_FSPECIAL, 1, grapple_hook_x, grapple_hook_y);
	        		grapple_hook_hitbox.hsp = grapple_hook_hsp;
	        		grapple_hook_hitbox.vsp = grapple_hook_vsp;
	        		grapple_hook_hitbox.agent_p_grapple_hitbox = true; // for use by articles
	        		
	        		// aim assist for drones
	        		grapple_hook_aim_obj = noone;
	        		var donor_article = instance_create(floor(x+(grapple_hook_x_origin+grapple_hook_x_offset)*spr_dir), floor(y+grapple_hook_y_origin + grapple_hook_y_offset), "obj_article3");
	        		donor_article.mask_index = sprite_get("grapple_assist_mask_" + string(spr_dir));
	        		with obj_article1 {
	        			if ("agent_p_grapplable" in self && agent_p_grapplable == 2 && place_meeting(x, y, donor_article)) {
	        				other.grapple_hook_aim_obj = self;
	        				//print_debug("found " + string(self));
	        			}
	        		}
	        		if (has_rune("M")) with oPlayer { // Rune M: player-targetted aim assist
	        			if (other != self && place_meeting(x, y, donor_article)) {
	        				other.grapple_hook_aim_obj = self;
	        				//print_debug("found " + string(self));
	        			}
	        		}
 	        		instance_destroy(donor_article);
	        		
    			}
    			
    			training_mode_alpha = 0.5;
    			
        		// no break
        	
        	case 3:
        	
        		if (grapple_hook_state == GRAPPLE_WALL_MOUNTED || grapple_hook_state == GRAPPLE_ARTICLE_MOUNTED) {
        			set_attack_value(attack, AG_NUM_WINDOWS, 5);
        			window = 5;
        			window_timer = 0;
        			
        			sound_play(sound_get("sfx_per_hookhit_2"), false, noone, 0.9, 1.05);
        		}
        		
        		else if (grapple_hook_state == GRAPPLE_DISABLED) {
        			window = 4;
        			window_timer = 0;
        		}
        		
        		if (window == 3 && training_mode_alpha > 0) training_mode_alpha -= 0.05
        		
	        	break;
	        
	        case 4:
	        	set_attack_value(attack, AG_NUM_WINDOWS, 4);
	        	can_wall_jump = true;
		    	break;
		    
		    // wall grapple
		    case 5:
		    	can_attack = true;
		    	can_special = true;
		    	can_shield = free; // so as to only permit air dodging
		    	can_strong = true;
		    	can_ustrong = true;
		    	can_jump = true;
		    	//fall_through = true;
		    	
		    	if (grapple_hook_state = GRAPPLE_DISABLED) {
        			set_state(free ? PS_IDLE_AIR : PS_WAVELAND);
        			if (vsp > -4 && free) vsp = -4;
        			attack_end();
        		}
        		
        		// slide behavior
        		else if (!free) {
        			
        			attack_air_limit[attack] = false; // refresh cooldown
        			if (get_gameplay_time() % 3 == 0) spawn_base_dust(x, y, "dash");
        			
        			// grounded air dodge (mainly for wavedashes)
        			if (shield_pressed) {
        				clear_button_buffer(PC_SHIELD_PRESSED);
        				set_state(PS_AIR_DODGE);
        			}
        			
        		}
        		
        		break;
        	
        	case 6:
        		can_move = false;
        		can_fast_fall = false;
        		if (grapple_hook_state == GRAPPLE_DISABLED) {
        			vsp = 0;
        			hsp = 2 * spr_dir;
        			window = 7;
        			window_timer = 0;
        		}
        		break;
        	
        	case 7:
        		if (window_timer == get_window_value(attack, window, AG_WINDOW_LENGTH)) vsp = -10;
        		break;
        	
        	case 8:
        	case 9:
        		// manual gravity (for parachute safety)
        		vsp += gravity_speed;
        		break;
	        
    	}
        break;
        
	case AT_DSPECIAL_AIR: 
		can_fast_fall = false;
		if (!free) {
			attack_end();
			attack = AT_DSPECIAL;
			// deliberately avoid resetting window/timer
		}
		// no break
	case AT_DSPECIAL:
        
        if (window == 1 && window_timer == get_window_value(attack, window, AG_WINDOW_LENGTH)) {
        	if (!instance_exists(dspec_explosive)) {
        		dspec_explosive = instance_create(floor(x), floor(y), "obj_article2");
        		if (free) vsp = (parachute_active ? -6 : -8);
        	}
        	else if (free) vsp = (parachute_active ? -3.5 : -4);
        }
        
        if (free) attack_air_limit[AT_DSPECIAL_AIR] = true;
        
        move_cooldown[AT_DSPECIAL] = 30; // not really necessary but telegraphs that this isn't spammable
        
        break;	
        
    case AT_USPECIAL:
    	can_wall_jump = (window > 1);
    	can_shield = (window > 1);
    	if (window == 1) {
    		dir_held = (left_down*-1) + (right_down);
    		vis_parachute_frame = 0;
    	}
    	else if (window == 2 && window_timer == 1) {
			sound_play(sound_get("sfx_per_hookend"))
			hsp = 3 * dir_held;
			vsp = (dir_held == 0 ? -9 : -8);
			parachute_active = true;
			vis_parachute_angle = hsp * 5 / air_max_speed;
    	}
    	if (window >= 2 && vis_parachute_frame < 2) vis_parachute_frame += 0.25;
        break;
    case AT_TAUNT: 
    case AT_TAUNT_2:
        if window == 2 {
            if window_timer == 5 && taunt_loops < 15{ // WARN: Possible repetition during hitpause. Consider using window_time_is(frame) https://rivalslib.com/assistant/function_library/attacks/window_time_is.html
                window_timer = 0
                taunt_loops++;
                //print("loop)")
            }
        }
        if window == 3 {
            taunt_loops = 0

        }

		if attack == AT_TAUNT_2 down_down = true
        break;
    case AT_USTRONG: 
        can_move = false;
        if (free) {
        	if (left_down)  hsp = clamp(hsp-0.1, -12, hsp);
        	if (right_down) hsp = clamp(hsp+0.1, hsp, 5);
        }
        
        if (window == 1) {
            fall_timer = 0;
            set_attack_value(AT_USTRONG, AG_CATEGORY, 2);
        }
        else if (window == 2 && window_timer == get_window_value(attack, window, AG_WINDOW_LENGTH)) {
        	ustrong_smear = spawn_hit_fx(x, y - 12, fx_ustrong1);
            ustrong_smear.depth = depth-1;
        	spawn_hit_fx(x, y, fx_ustrong2);
        	vsp = -12;
        }
        else if (window == 4 || window == 5) {
        	fall_timer++;
        	if (fall_timer > 33) {
        		strong_charge = 0;
        		iasa_script();
        		create_hitbox(attack, 2, x, y);
        	}
        }
        
        if (hitpause && instance_exists(ustrong_smear)) {
        	ustrong_smear.step_timer--;
        }
        
        can_fast_fall = (window == 5 && fall_timer > 33);
        can_wall_jump = (window == 5);
        fall_through = (window == 4 || window == 5 && fall_timer < 33) && !was_parried;
    break;
    
    case AT_DSTRONG: // self-parry
    
    	if (window == 2 && window_timer == get_window_value(attack, window, AG_WINDOW_LENGTH) && !hitpause) {
	    	var hbox = create_hitbox(attack, 1, x, y);
	    	hbox.can_hit_self = true;
	    	perfect_dodging = 1;
	    	dstrong_fx = spawn_hit_fx(x, y, fx_parry_flash);
    	}
    	
    	if (window == 3 && hitpause) {
    		dstrong_fx.step_timer--;
    		if (dstrong_cancel_parry_stun && !has_hit && hitstop > 2) {
	            hitstop = 2;
	            hitstop_full = 2;
	        }
    	}
    	
    	if (window == 4 && window_timer == 1) {
    		if (dstrong_cancel_parry_stun) {
    			was_parried = false;
    			dstrong_cancel_parry_stun = false;
    			invince_time = 10;
    		} else {
    			invincible = false;
    		}
    	}
    	
    	// necessary for obvious reasons
    	// also bandaids a bug where when using the move twice in succession,
    	// the hitbox would be unable to hit perry until late in the move,
    	// thus killing him
    	move_cooldown[AT_DSTRONG] = 20;
    	
    	break;
	case AT_FSTRONG: 
		if window == 2 && window_timer == 7 {
			sound_play(asset_get("sfx_clairen_sword_deactivate"))
		}
		if window == 3  {
			if window_timer == 1 && has_hit {
				sound_play(asset_get("sfx_absa_singlezap2"))

			}
			if window_timer == 3 {
				sound_play(asset_get("sfx_absa_new_whip1"))
			}

		}
	break;
    
}

// command grab code
if (instance_exists(grabbed_player_obj) && get_window_value(attack, window, AG_WINDOW_GRAB_OPPONENT)) {
	
	//first, drop the grabbed player if this is the last window of the attack, or if they somehow escaped hitstun.
	if (window >= get_attack_value(attack, AG_NUM_WINDOWS)) { grabbed_player_obj = noone; }
	else if (grabbed_player_obj.state != PS_HITSTUN && grabbed_player_obj.state != PS_HITSTUN_LAND) { grabbed_player_obj = noone; }
	
	else {
		//keep the grabbed player in hitstop until the grab is complete.
		grabbed_player_obj.hitstop = 2;
		grabbed_player_obj.hitpause = true;
		
		//if this is the first frame of a window, store the grabbed player's relative position.
		if (window_timer <= 1) {
			grabbed_player_relative_x = grabbed_player_obj.x - x;
			grabbed_player_relative_y = grabbed_player_obj.y - y;
		}
		
		// pull opponent to window's grab positions
		var pull_to_x = get_window_value(attack, window, AG_WINDOW_GRAB_POS_X) * spr_dir;
		var pull_to_y = get_window_value(attack, window, AG_WINDOW_GRAB_POS_Y);
			
		//using an easing function, smoothly pull the opponent into the grab over the duration of this window.
		grabbed_player_obj.x = x + ease_circOut( grabbed_player_relative_x, pull_to_x, window_timer, window_length);
		grabbed_player_obj.y = y + ease_circOut( grabbed_player_relative_y, pull_to_y, window_timer, window_length);
		
	}
	
} else if (instance_exists(grabbed_player_obj)) { //if grabbed player exists but attack no longer grabs
	grabbed_player_obj = noone;
}

// walljump code
if (get_window_value(attack,window,AG_WINDOW_CAN_WALLJUMP)) {
	can_wall_jump = true;
}
// cosmetic attack fx
switch(attack) {
    case AT_JAB:
    	//a
        break;
    case AT_FTILT:
        //a
        break;
    case AT_DTILT:
        //a
        break;
    case AT_UTILT:
        //a
        break;
    case AT_DATTACK:
        //a
        break;
        
    case AT_NAIR:
        //a
        break;
    case AT_FAIR:
        //a
        break;
    case AT_BAIR:
        //a
        break;
    case AT_DAIR:
        //a
        break;
    case AT_UAIR:
        //a
        break;
    
    case AT_NSPECIAL:
        //a
        break;
    case AT_FSPECIAL:
        //a
        break;
    case AT_DSPECIAL:
        //a
        break;
    case AT_USPECIAL:
        //a
        break;
    
    case AT_TAUNT:
		//a
    	break;
    case 2: //intro
		if window == 4 && window_timer == 1 {
			sound_play(sound_get("sfx_perry_stinger"))
		}
		break;
	case 3: //intro 2

		if window == 4 && window_timer == 1 {
			sound_play(sound_get("sfx_perry_stinger"))
		}
		break;
}

// Defines

#define sound_window_play //basically a shortcut to avoid repeating if statements over and over
/// sound_window_play(_window, _timer, _sound, _looping = false, _panning = noone, _volume = 1, _pitch = 1)
var _window = argument[0], _timer = argument[1], _sound = argument[2];
var _looping = argument_count > 3 ? argument[3] : false;
var _panning = argument_count > 4 ? argument[4] : noone;
var _volume = argument_count > 5 ? argument[5] : 1;
var _pitch = argument_count > 6 ? argument[6] : 1;
if window == _window && window_timer == _timer {
    sound_play(_sound,_looping,_panning,_volume,_pitch)
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

// #region vvv LIBRARY DEFINES AND MACROS vvv
// DANGER File below this point will be overwritten! Generated defines and macros below.
// Write NO-INJECT in a comment above this area to disable injection.
#define window_time_is(frame) // Version 0
    // Returns if the current window_timer matches the frame AND the attack is not in hitpause
    return window_timer == frame and !hitpause
// DANGER: Write your code ABOVE the LIBRARY DEFINES AND MACROS header or it will be overwritten!
// #endregion

if (hitstop > 0) exit;
if (!free) hsp = 0;

// Bash handling
if (getting_bashed) { // halt time progress
	venus_article_reflect = 0;
	reflected_player_id = bashed_id;
	vis_warn_phase = -1;
	hsp = 0;
	vsp = 0;
	exit;
}
if (player != orig_player) { // bash release
	venus_article_reflect = 1;
	player = orig_player;
	reflect_dir = point_direction(0, 0, hsp, vsp);
	set_state(6);
	if (!free) {
		free = true;
		y -= 1;
	}
}

// Venus compat
if (venus_reflected) { // this variable gets reset at the bottom of the script for safety
	venus_was_reflected = true;
	venus_rune_ID.hp -= 0.5;
	reflected_player_id = venus_rune_ID.player_id;
}

// Timer / CD management
state_timer++;
player_id.dspec_article_cooldown = player_id.dspec_max_article_cooldown;

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
}

switch(state) { // use this one for doing actual article behavior
	
	case 0: // falling

		if (!free) {
			if (falling_hitbox_hit) {
				set_state(3); // exploding
				hitstun_triggered = true;
			}
			else set_state(1); // idle
			if (instance_exists(falling_hitbox)) falling_hitbox.destroyed = true;
			sound_play(asset_get("sfx_springswitch"));
			venus_was_reflected = false;
			
		}
		else {
			
			vsp = clamp(vsp+0.4, -16, 16); 
			
			if (state_timer == 1) {
				falling_hitbox = create_hitbox(AT_DSPECIAL_AIR, 1, x, y-30);
				falling_hitbox.agent_p_ignore_drone = true;
				falling_hitbox.owner_button = self;
				falling_hitbox.hsp = hsp;
				falling_hitbox.vsp = vsp;
				falling_hitbox.venus_article_proj_ignore = true;
			}
			if (!instance_exists(falling_hitbox)) { // hitbox was destroyed, so despawn article
				if (venus_was_reflected) {
					set_state(7);
				} else {
					var vfx = spawn_hit_fx(x+spr_dir, y, player_id.vfx_dspec_button);
	        		vfx.depth = depth-1;
	        		should_die = true;
				}
			}
			else {
				falling_hitbox.x = x;
				falling_hitbox.y = y;
				falling_hitbox.hsp = hsp;
				falling_hitbox.vsp = vsp;
				falling_hitbox.length++;
				if (venus_reflected) { // fake reflect
					if (falling_hitbox.can_hit_self ) for (var i = 0; i < 20; i++) falling_hitbox.can_hit[i] = true;
					falling_hitbox.can_hit_self = true;
					falling_hitbox.can_hit[reflected_player_id.player] = false;
					falling_hitbox.enemies = 0;
				}
			}
			
		}
		
		with (obj_article1) {
        	if (player_id != other.player_id) continue;
        	
        	var colliding = place_meeting(x, y, other);
        	
        	if (colliding) {
        		is_primed = true;
        		if (state == 1) state_timer = 0;
        		//lifetime_decayed = 0;
        		sound_play(asset_get("sfx_ell_dspecial_drop"))
        		var vfx = spawn_hit_fx(x+spr_dir, y, player_id.vfx_dspec_button);
        		vfx.depth = depth-1;
        		if (instance_exists(other.falling_hitbox)) other.falling_hitbox.destroyed = true;
        		instance_destroy(other);
        		player_id.button_obj = self;
        		exit;
        	}
        }
		break;
		
    case 1: // prep
        
        venus_article_reflect = 0;
        
        if (free) {
        	set_state(0);
        	venus_article_reflect = 1;
        }
    	
        if (state_timer == 23) sound_play(asset_get("sfx_ell_dspecial_drop"));
        if (state_timer >= 25) {
        	set_state(2);
        }
        break;
        
    case 2: // idle
    
        if (free) set_state(0);
        
        with (oPlayer) {
        	if (self == other.player_id) continue;
        	
        	if (state_cat == SC_HITSTUN) {
        		with (other) var colliding = collision_rectangle(x-(trigger_w/2), y, x+(trigger_w/2), y-(trigger_h_hitstun), other.hurtboxID, true, false);
        	} else {
        		with (other) var colliding = collision_rectangle(x-(trigger_w/2), y, x+(trigger_w/2), y-(trigger_h), other.hurtboxID, true, false);
        	}
        	
        	if (colliding) {
        		other.state = 3;
        		other.state_timer = 0;
        		other.hitstun_triggered = other.hitstun_triggered || (state_cat == SC_HITSTUN);
        	}
        }
        
        if (state_timer >= max_primed_lifetime) set_state(5);
        
        break;
    
    case 3: // exploding
    	
    	if (state_timer == 1 || state_timer == 8) sound_play(sound_get("snake_prime1"));
    	
        if (state_timer >= 9 || (state_timer >= 3 && hitstun_triggered)) { // very temp! 	//old = (state_timer >= 14 || (state_timer >= 9 && hitstun_triggered))
            sound_play(sound_get("boom"));
            spawn_hit_fx(x, y+6, player_id.vfx_dspec_explode_gr);
            set_state(4);
        }
        break;
    
    case 4: // exploded	
    	unbashable = true;
    	if (state_timer == 3) {
    		var boom = create_hitbox(AT_DSPECIAL, hitbox_type, x, y-4);
    		boom.can_hit_self = rune_can_hit_self
    		boom.venus_article_proj_ignore = true;
    		should_die = true;
    	}
    	break;
    
    case 5: // despawn
    	if (state_timer == 1) sound_play(asset_get("sfx_springswitch"));
    	if (free) {
    		var vfx = spawn_hit_fx(x+spr_dir, y, player_id.vfx_dspec_button);
        	vfx.depth = depth-1;
        	should_die = true;
    	}
    	else if (state_timer >= 9) should_die = true;
    	break;
    	
    case 6: // parried / bashed
    	if (state_timer == 1) {
            hbox = create_hitbox(AT_DSPECIAL_AIR, 1, x, y);
            hbox.agent_p_ignore_drone = true;
            hbox.owner_button = self;
            hbox.hit_angle = 90;
            hbox.venus_article_proj_ignore = true;
            
        	// fake reflect
        	if (hbox.can_hit_self) for (var i = 0; i < 20; i++) hbox.can_hit[i] = true;
            hbox.can_hit_self = true;
            hbox.can_hit[reflected_player_id.player] = false;
            hbox.venus_article_proj_ignore = true;
            
            hsp = lengthdir_x(12, reflect_dir);
            vsp = lengthdir_y(12, reflect_dir);
            
            venus_article_reflect = 1;
        }
        
        if (!instance_exists(hbox) || state_timer > 20 || hit_wall || !free) {
        	set_state(7);
        	sound_play(asset_get("sfx_ell_small_missile_ground"));
            spawn_hit_fx(x, y+6, player_id.vfx_dspec_explode);
        	if (instance_exists(hbox)) hbox.destroyed = true;
        	hsp = 0;
        	vsp = 0;
        }
        else {
        	hbox.x = x;
			hbox.y = y;
        	hbox.hsp = hsp;
        	hbox.vsp = vsp;
        	hbox.length++;
        	if (venus_reflected) { // fake reflect
				hbox.can_hit_self = true;
				hbox.enemies = 0;
				hbox.can_hit[reflected_player_id.player] = false;
			}
        }
        
        if (venus_reflected) {
        	reflect_dir = point_direction(0, 0, hsp, vsp);
        	state_timer = 2;
        }
        break;
        
    case 7: // explode (bashed/parried)
    	unbashable = true;
    	if (state_timer == 3) {
    		var boom = create_hitbox(AT_DSPECIAL, hitbox_type, x, y-4);
    		boom.can_hit_self = true;
            boom.can_hit[reflected_player_id.player] = false;
            boom.venus_article_proj_ignore = true;
    		should_die = true;
    	}
    	break;
        
}

switch(state) { // use this one for changing sprites and animating
	case 0: // falling
		sprite_index = sprite_get(is_ea ? "dspec_proj_ea" : "dspec_proj")
		if (venus_was_reflected) sprite_index = sprite_get("null");
		vis_warn_phase = -1;
		break;
    case 1: // prepping
    	sprite_index = sprite_get(is_ea ? "dspecial_art_ea" : "dspecial_art")
        image_index = (state_timer < 4) ? 0 : 1;
        break;
    case 2: // idle
    	sprite_index = sprite_get(is_ea ? "dspecial_art_ea" : "dspecial_art")
        image_index = (state_timer < 2) ? 2 : 3;
        vis_warn_phase = (state_timer < 9) ? state_timer/3 : 3
        vis_warn_y_offset = 2 * round(sin(pi*state_timer/30));
        break;
    case 3: // exploding
    	sprite_index = sprite_get(is_ea ? "dspecial_art_ea" : "dspecial_art")
        image_index = 5; 
        vis_warn_phase = (state_timer < 2) ? 4 + state_timer/1 : 6
        vis_warn_y_offset = 0;
        break;
    case 4: // exploded
    	sprite_index = sprite_get("null");
    	vis_warn_phase = -1;
    	break;
    case 5: // despawn
    	if (!free) {
    		image_index = 4 + (state_timer / 3);
	    	vis_warn_phase = 2 - (state_timer / 3);
	    	vis_warn_y_offset = 0;
    	}
    	else { // really more of a failsafe than anything but y'know
    		sprite_index = sprite_get("null");
    		vis_warn_phase = -1;
    	}
    	break;
    case 6: // parried / bashed
		sprite_index = sprite_get("null");
		vis_warn_phase = -1;
}

// don't forget that articles aren't affected by small_sprites

if (should_die) { //despawn and exit script
	if (was_parried) {
		var cd_manager = instance_create(floor(x), floor(y), "obj_article3");
		cd_manager.state = 20;
		cd_manager.vis_frame = 7;
		cd_manager.vis_y_offset = 0;
	}
	if (player_id.button_obj == self) player_id.button_obj = noone;
    instance_destroy();
    exit;
}


// compat
venus_reflected = 0;

#define set_state
var _state = argument0;
state = _state;
state_timer = 0;

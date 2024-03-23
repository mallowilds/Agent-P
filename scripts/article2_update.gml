
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
}

switch(state) { // use this one for doing actual article behavior
	
	case 0: // falling
		vsp = clamp(vsp+0.6, 3, 10);
		if (!free) set_state(1);
	
    case 1: // prep
        
        if (free) set_state(0);
    	
        if (state_timer == 23) sound_play(asset_get("sfx_ell_dspecial_drop"));
        if (state_timer >= 25) set_state(2);
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
        break;
    
    case 3: // exploding
    	
    	if (state_timer == 1 || state_timer == 8) sound_play(sound_get("snake_prime1"));
    	
        if (state_timer >= 14 || (state_timer >= 6 && hitstun_triggered)) { // very temp!
        	create_hitbox(AT_NSPECIAL, 3, x, y);
            sound_play(asset_get("sfx_ell_small_missile_ground"));
            spawn_hit_fx(x, y, HFX_ELL_FSPEC_BREAK);
            should_die = true;
        }
        break;
        
}

switch(state) { // use this one for changing sprites and animating
	case 0: // falling
		sprite_index = sprite_get(is_ea ? "dspec_proj_ea" : "dspec_proj")
		break;
    case 1: // prepping
    	sprite_index = sprite_get(is_ea ? "dspecial_art_ea" : "dspecial_art")
        image_index = (state_timer < 4) ? 0 : 1;
        break;
    case 2: // idle
    	sprite_index = sprite_get(is_ea ? "dspecial_art_ea" : "dspecial_art")
        image_index = (state_timer < 4) ? 2 : 4-floor((state_timer/30)%2);
        break;
    case 3: // exploding
    	sprite_index = sprite_get(is_ea ? "dspecial_art_ea" : "dspecial_art")
        image_index = 5;
        break;
}

// don't forget that articles aren't affected by small_sprites

if (should_die) { //despawn and exit script
	player_id.move_cooldown[AT_DSPECIAL] = 90;
	player_id.move_cooldown[AT_DSPECIAL_AIR] = 90;
    instance_destroy();
    exit;
}



#define set_state
var _state = argument0;
state = _state;
state_timer = 0;

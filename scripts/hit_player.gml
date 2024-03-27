
#macro GRAPPLE_DISABLED 0
#macro GRAPPLE_ACTIVE 1
#macro GRAPPLE_RETURNING 2
#macro GRAPPLE_PLAYER_MOUNTED 3
#macro GRAPPLE_WALL_MOUNTED 4
#macro GRAPPLE_ARTICLE_MOUNTED 5

//                           --hit stuff--                                    //


var atk = my_hitboxID.attack
var hbox = my_hitboxID.hbox_num


// Galaxy tracking
if (!hit_player_obj.clone) {
	hit_last_frame[num_hit_last_frame] = hit_player_obj;
	num_hit_last_frame++;
}


// FSpec grapple
if (atk == AT_FSPECIAL && hbox == 1 && (state == PS_ATTACK_GROUND || state == PS_ATTACK_AIR) && attack == AT_FSPECIAL) {
	gh_state = GRAPPLE_PLAYER_MOUNTED;
	gh_timer = 0;
	gh_target = hit_player_obj;
	gh_target_x_offset = (gh_x - hit_player_obj.x) / 2; // hitbox extension safety
	gh_target_y_offset = (gh_y - hit_player_obj.y);
	
	hit_player_obj.hitstop = 2;
	hit_player_obj.hitstop_full = 2;
	
	set_attack_value(AT_FSPECIAL, AG_NUM_WINDOWS, 9);
	window = 6;
	window_timer = 6;
	
	hsp = 0;
	vsp = 0;
	
	// djumps = 0; // reset djumps //you are fucked up and evil
	//sound_play(sound_get("sfx_per_hookhit_2"), false, noone, 0.9, 1.05);
}

if atk == AT_FSTRONG {
        sound_play(asset_get("sfx_absa_singlezap2"))
}
// DSpec falling hitbox
if (atk == AT_DSPECIAL_AIR && "owner_button" in my_hitboxID) {
    sound_play(asset_get("sfx_absa_singlezap2"))
	my_hitboxID.owner_button.falling_hitbox_hit = true;
}


// Pop up on ustrong silly hit
if (atk == AT_USTRONG && hbox == 2) {
	window = 6;
	window_timer = 0;
	old_vsp = -6.5;
}


// hitbox lerp code
var is_forcing_flinch = get_hitbox_value(atk, hbox, HG_FORCE_FLINCH) && !hit_player_obj.free
if (get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_HAS_LERP) == true && !is_forcing_flinch) {
	if (my_hitboxID.type == 1) { //if physical, pull relative to player
		hit_player_obj.x = lerp(hit_player_obj.x, x + get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_LERP_POS_X)*spr_dir, get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_LERP_PERCENT));
		hit_player_obj.y = lerp(hit_player_obj.y, y + get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_LERP_POS_Y), get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_LERP_PERCENT));
	} else if (my_hitboxID.type == 2) { // otherwise pull relative to hitbox
		hit_player_obj.x = lerp(hit_player_obj.x, my_hitboxID.x + get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_LERP_POS_X)*spr_dir, get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_LERP_PERCENT));
		hit_player_obj.y = lerp(hit_player_obj.y, my_hitboxID.y + get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_LERP_POS_Y), get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_LERP_PERCENT));
	}
}



// Rune L: parachute momentum
if (has_rune("L") && parachute_active) {
	switch(my_hitboxID.attack) {
		case AT_NAIR:
			if (old_vsp > -6) old_vsp = -6;
			break;
		case AT_FAIR:
			if (old_hsp*spr_dir < 9) old_hsp = 9 * spr_dir;
			else old_hsp += 1 * spr_dir;
			if (hbox == 3 && old_vsp > -4) old_vsp = -4;
			else if (old_vsp > 0) old_vsp = 0;
			break;
		case AT_BAIR:
			if (old_hsp*spr_dir > -10) old_hsp = -10 * spr_dir;
			if (old_vsp > -4) old_vsp = -4;
			break;
		case AT_UAIR:
			if (hbox == 1 && old_vsp > -2) old_vsp = -2;
			if (hbox == 2 && old_vsp > -8) old_vsp = -8;
			break;
		case AT_DAIR:
			if (old_vsp > -5) old_vsp = -5;
			break;
	}
}


//                          --hit gamefeel--                                  //

switch(my_hitboxID.attack) {
    case AT_JAB:
        //a
        break;
    case AT_FTILT:
        //a
        break;
    case AT_DTILT:
        sound_play(asset_get("sfx_syl_fspecial_bite"), 0, noone, .4, 1.05)
		sound_play(sound_get("sfx_per_chomp"), 0, noone, .8, 1.01)
        var _x = (my_hitboxID.x + hit_player_obj.x) / 2 + (get_hitbox_value(AT_DTILT, 1, HG_VISUAL_EFFECT_X_OFFSET) * spr_dir);
        var _y = (my_hitboxID.y + hit_player_obj.y) / 2 + get_hitbox_value(AT_DTILT, 1, HG_VISUAL_EFFECT_Y_OFFSET);
        var dir_fx = spawn_hit_fx(_x, _y, 303);
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
        var _x = (my_hitboxID.x + hit_player_obj.x) / 2 + (get_hitbox_value(AT_FAIR, 1, HG_VISUAL_EFFECT_X_OFFSET) * spr_dir);
        var _y = (my_hitboxID.y + hit_player_obj.y) / 2 + get_hitbox_value(AT_FAIR, 1, HG_VISUAL_EFFECT_Y_OFFSET);
        var dir_fx = spawn_hit_fx(_x, _y, 303);
        break;
    case AT_BAIR:
        sound_play(asset_get("sfx_pom_slap1"), 0, noone, 1.3, 1.1)
        //a
        break;
    case AT_DAIR:
        //a
        break;
    case AT_UAIR:
        //a
        break;
        
    case AT_FSTRONG:
    	//a
    
    case AT_USTRONG:
    	if (hbox == 2) sound_play(asset_get(has_rune("D") ? "sfx_blow_heavy1" : "sfx_blow_weak1"));
    	break;
    case AT_DSTRONG:
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
    
}

#define get_effect_offset_x

return (hit_player_obj.x + x) * 0.5 + get_hitbox_value(my_hitboxID.attack, my_hitboxID.hbox_num, HG_VISUAL_EFFECT_X_OFFSET) * spr_dir;

#define get_effect_offset_y

return (hit_player_obj.y + y)*0.5 + get_hitbox_value(my_hitboxID.attack,my_hitboxID.hbox_num,HG_VISUAL_EFFECT_Y_OFFSET) - 25;

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
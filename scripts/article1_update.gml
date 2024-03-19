
state_timer++;


switch(state) { // use this one for doing actual article behavior

    case 0: // spawn
    
        if (state_timer == 1) {
            hsp = (throw_dir == -1) ? 2 : 4 + (2 * throw_dir);
            hsp *= spr_dir;
            vsp = -6 + (2.5 * throw_dir);
            
            hbox = create_hitbox(AT_NSPECIAL, 1, x, y);
        }
        
        if (vsp < 6) vsp += 0.2;
        
        if (state_timer == 25) {
            set_state(1);
            if (instance_exists(hbox)) hbox.destroyed = true;
        }
        
        else if (instance_exists(hbox)) {
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
        if (state_timer + lifetime_decayed >= max_lifetime && !agent_p_grappling) {
            set_state(2);
        }
        break;
        
    case 2: //die
        if (state_timer == 20) { // die after 20 frames
            should_die = true;
        }
        break;
        
}

switch(state) { // use this one for changing sprites and animating
    case 0: // spawn
        image_index = (state_timer / 4) % 4;
        break;
    case 1: // idle
        image_index = 4 + (state_timer / 4) % 12;
        break;
    case 2: //die
        image_index = (state_timer / 4) % 4;
        break;
}
// don't forget that articles aren't affected by small_sprites

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

if (hitpause) exit;
state_timer++;


switch(state) { // use this one for doing actual article behavior

    case 0: // spawn
    
        if (state_timer == 1) {
            hsp = (throw_dir == -1) ? 2 : 4 + (2 * throw_dir);
            hsp *= spr_dir;
            vsp = -6 + (2.5 * throw_dir);
            
            hbox = create_hitbox(AT_NSPECIAL, 1, x, y);
            hbox.agent_p_grapple_hitbox = true;
        }
        
        if (vsp < 6) vsp += 0.2;
        
        if (lightweight_detect_hitboxes(mask_index, 50)) set_state(3);
        
        else if (state_timer == 25) {
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
        if (lightweight_detect_hitboxes(mask_index, 50)) set_state(3);
        else if (state_timer + lifetime_decayed >= max_lifetime && !agent_p_grappling) set_state(2);
        break;
        
    case 2: // naturally despawn
        should_die = true;
        var despawn_obj = instance_create(x, y, "obj_article3");
        despawn_obj.state = 02;
        despawn_obj.vis_frame = image_index;
        despawn_obj.vis_alpha = 1;
        break;
    
    case 3: // hit -> explode
        should_die = true;
        var despawn_obj = instance_create(x, y, "obj_article3");
        despawn_obj.state = 03;
        despawn_obj.vis_frame = image_index;
        despawn_obj.hit_angle = hit_angle;
        break;
        
}

switch(state) { // use this one for changing sprites and animating
    case 0: // spawn
        image_index = (state_timer / 4) % 4;
        break;
    case 1: // idle
        image_index = 4 + (state_timer / 4) % 12;
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

// Adapted from Desperado signpost.
#define lightweight_detect_hitboxes(hitbox_mask, sim_percent)
    
    var old_mask = mask_index;
    mask_index = hitbox_mask;

    var hbox = noone;
    with pHitBox {
        if (place_meeting(x, y, other) && (hit_priority > 0) && "agent_p_grapple_hitbox" not in self) {
            if (hbox == noone || type == 1 && hbox.type == 2 || hit_priority > hbox.hit_priority) {
                hbox = self;
            }
        }
    }
    
    if (hbox != noone) {
        var sim_kb = ceil(get_kb_formula(sim_percent, 1, get_match_setting(SET_SCALING), hbox.damage, hbox.kb_value, hbox.kb_scale));
        sim_percent *= 0.1;
        
        // store hit_angle
        hit_angle = hbox.kb_angle;
        if (hit_angle == 361) hit_angle = free ? 45 : 40;
        if (hbox.hit_flipper == 5) hit_angle = 180 - hit_angle;
        if (spr_dir == -1) hit_angle = 180 - hit_angle;
        // deliberately neglecting most angle flippers for now since it's visual-only anyway
        
        if (get_local_setting(SET_HUD_SHAKE)) shake_camera(sim_kb, ceil(sim_kb/1.5 < 2 ? 2 : sim_kb/1.5));
        
        hitstop = floor(hbox.hitpause + hbox.extra_hitpause + (hbox.hitpause_growth*sim_percent));
        if (hbox.type == 1) with (hbox.player_id) {
            if (!hitpause) {
                old_hsp = hsp;
                old_vsp = vsp;
            }
            hitpause = true;
            has_hit = true;
            if (hitstop < hbox.hitpause + (hbox.hitpause_growth*sim_percent)) {
                hitstop = hbox.hitpause + (hbox.hitpause_growth*sim_percent);
                hitstop_full = hbox.hitpause + (hbox.hitpause_growth*sim_percent);
            }
            
        }
        sound_play(hbox.sound_effect);
        with hbox spawn_hit_fx((x+other.x)/2+(spr_dir*hit_effect_x), (y+other.y-50)/2+(hit_effect_y), hit_effect);
        
        // SK bounce for fun~
        if (hbox.player_id.url == CH_SHOVEL_KNIGHT && hbox.attack == AT_DAIR && hbox.type == 1) {
            if (hbox.player_id.vsp > -5) hbox.player_id.vsp = -5;
            if (hbox.player_id.old_vsp > -5) hbox.player_id.old_vsp = -5;
            if (hbox.hbox_num == 3) sound_play(asset_get("sfx_shovel_hit_light1")); // idk why this one doesn't have sfx lol
        }
        
        mask_index = old_mask;
        return true;
    }
    
    mask_index = old_mask;
    return false;

// article1_update - runs every frame the article exists
// Minor objects

/*STATE LIST

- Default (-1): Failed initialization

- 00: Parachute
- 01: Spawn platform
- 02: Drone despawn ~ fly away
- 03: Drone despawn ~ explode


*/



switch state {
    
    // Parachute
    case 00:
        if (state_timer == 0) {
            vis_angle = player_id.vis_parachute_angle;
            vis_alpha = 1;
            vis_frame = player_id.vis_parachute_frame;
            hsp = vis_angle/38;
            vsp = -1.2;
        }
        vsp -= 0.2;
        if (state_timer > 10) vis_alpha -= 0.1;
        if (vis_frame < 2) vis_frame += 0.25;
        if (vis_alpha <= 0) {
            instance_destroy();
            exit;
        }
        break;
    
    // Spawn platform
    case 01:
        if (state_timer == 0) {
            hsp = 0.5*spr_dir;
            vsp = 0;
        }
        if (abs(hsp) < 6) hsp += 1 * spr_dir;
        vsp -= 0.2;
        if (state_timer > 10) vis_alpha -= 0.1;
        if (vis_alpha <= 0) {
            instance_destroy();
            exit;
        }
        break;
    
    // Drone despawn ~ fly away
    case 02:
        if (state_timer == 0) {
            hsp = 0.5*spr_dir;
            vsp = 0;
        }
        vis_frame = 4 + (state_timer / 4) % 12;
        if (abs(hsp) < 3) hsp += 0.5 * spr_dir;
        vsp -= 0.2;
        if (state_timer > 2) vis_alpha -= 0.1;
        if (vis_alpha <= 0) {
            instance_destroy();
            exit;
        }
        break;
    
    // Drone despawn ~ explode
    case 03:
        if (state_timer == 0) {
            hsp = lengthdir_x(7, hit_angle);
            vsp = lengthdir_y(7, hit_angle);
        }
        else do_air_friction(0.3);
        vis_frame = 4 + (state_timer / 4) % 12;
        if (state_timer > 10) {
            sound_play(asset_get("sfx_ell_small_missile_ground"));
            spawn_hit_fx(x, y, HFX_ELL_FSPEC_BREAK);
            instance_destroy();
            exit;
        }
        break;
    
    //#region Failed initialization
    default:
        print_debug("Error: article 3 was not properly initialized")
        instance_destroy();
        exit;
    //#endregion
    
}

state_timer++;


#define do_air_friction(decel)
    var dec_dir = point_direction(hsp, vsp, 0, 0);
    var hsp_dec = lengthdir_x(decel, dec_dir);
    var vsp_dec = lengthdir_y(decel, dec_dir);
    
    hsp = (abs(hsp_dec) < abs(hsp)) ? (hsp + hsp_dec) : 0;
    vsp = (abs(vsp_dec) < abs(vsp)) ? (vsp + vsp_dec) : 0;
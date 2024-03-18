
// article1_update - runs every frame the article exists
// Minor objects

/*STATE LIST

- Default (-1): Failed initialization

- 00: Parachute
- 01: Spawn platform



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
    
    //#region Failed initialization
    default:
        print_debug("Error: article 3 was not properly initialized")
        instance_destroy();
        exit;
    //#endregion
    
}

state_timer++;
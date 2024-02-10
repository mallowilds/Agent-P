
// article1_update - runs every frame the article exists
// Minor objects

/*STATE LIST

- Default (-1): Failed initialization

- 00: Parachute




*/



switch state {
 
    //#region VFX Sentinels
    
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
        if (vis_frame < 2) vis_frame += 0.34;
        if (vis_alpha <= 0) {
            instance_destroy();
            exit;
        }
        break;
    
    //#endregion
    
    //#region Failed initialization
    default:
        print_debug("Error: article 3 was not properly initialized")
        instance_destroy();
        exit;
    //#endregion
    
}

state_timer++;
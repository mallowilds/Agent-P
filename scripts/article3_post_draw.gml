
switch state {
 
    //#region Parachute
    
    // Parachute
    case 00:
        if (!"vis_angle" in self) exit;
        if (get_player_color(player) == 0) {
            draw_sprite_ext(sprite_get("parachute"), vis_frame, x, y, 1, 1, vis_angle, c_white, vis_alpha);
        }
        else {
            with (player_id) shader_start();
            draw_sprite_ext(sprite_get("parachute_col"), vis_frame, x, y, 1, 1, vis_angle, c_white, vis_alpha);
            shader_end();
        }
        
        break;
    
    case 01:
        draw_sprite_ext(sprite_get("plat_fly"), 0, x, y, spr_dir, 1, 0, c_white, vis_alpha);
        break;
    
    case 02:
        draw_sprite_ext(sprite_get("drone"), vis_frame, x, y, spr_dir, 1, 0, c_white, vis_alpha);
        break;
    
    
    // Rune A manager
    case 10:
        if (player_id.rune_a_alpha < 1) {
            with (player_id) shader_start();
            draw_sprite_ext(player_id.sprite_index, player_id.image_index, player_id.x, player_id.y, 1, 1, 0, c_white, player_id.rune_a_alpha);
            shader_end();
        }
        break;
    
    //#endregion
    
}
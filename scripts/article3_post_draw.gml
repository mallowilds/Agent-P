
switch state {
 
    //#region Parachute
    
    // Parachute
    case 00:
        if (!"vis_angle" in self) exit;
        draw_sprite_ext(sprite_get("parachute"), vis_frame, x, y, 1, 1, vis_angle, c_white, vis_alpha);
        break;
    
    case 01:
        draw_sprite_ext(sprite_get("plat_fly"), 0, x, y, spr_dir, 1, 0, c_white, vis_alpha);
        break;
    
    case 02:
        draw_sprite_ext(sprite_get("drone"), vis_frame, x, y, spr_dir, 1, 0, c_white, vis_alpha);
        break;
    
    case 03:
        draw_sprite_ext(sprite_get("drone"), vis_frame, x, y, spr_dir, 1, 0, c_white, 1);
        break;
    
    //#endregion
    
}
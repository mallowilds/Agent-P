
switch state {
 
    //#region Parachute
    
    // Parachute
    case 00:
        if (!"vis_angle" in self) exit;
        draw_sprite_ext(sprite_get("parachute"), vis_frame, x, y, 1, 1, vis_angle, c_white, vis_alpha);
        break;
    
    //#endregion
    
}
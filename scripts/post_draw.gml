// use this to draw stuff


// Hitbox handling
if (get_match_setting(SET_HITBOX_VIS)) {
    if ((state == PS_ATTACK_GROUND || state == PS_ATTACK_AIR) && attack == AT_FSPECIAL) {
        if (window == 2) {
            draw_sprite_ext(sprite_get("grapple_assist_mask_" + string(spr_dir)), 0, floor(x+(grapple_hook_x_origin+grapple_hook_x_offset)*spr_dir), floor(y+grapple_hook_y_origin + grapple_hook_y_offset), 1, 1, 0, c_white, 0.5);
        }
        else if (window == 3) {
            draw_sprite_ext(sprite_get("grapple_assist_mask_" + string(spr_dir)), 0, floor(x+(grapple_hook_x_origin+grapple_hook_x_offset)*spr_dir), floor(y+grapple_hook_y_origin + grapple_hook_y_offset), 1, 1, 0, c_white, training_mode_alpha);
        }
    }
}
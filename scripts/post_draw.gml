// use this to draw stuff



// Respawn platform
if (plat_active) {
    if (is_ea) draw_sprite_ext(sprite_get("plat_idle_ea"), get_gameplay_time()/5, x, y, spr_dir, 1, 0, c_white, 1);
    else {
        shader_start();
        draw_sprite_ext(sprite_get("plat_idle"), get_gameplay_time()/5, x, y, spr_dir, 1, 0, c_white, 1);
        shader_end();
    }
}

// Early access color correction
if (is_ea && (state == PS_ATTACK_AIR || state == PS_ATTACK_GROUND)) {
    if (attack == AT_FSPECIAL && image_index <= 11) {
        draw_sprite_ext(sprite_get("fspec_eaover"), image_index, x, y, spr_dir, 1, 0, c_white, 1);
    }
    else if (attack == AT_NSPECIAL && image_index <= 2) {
        draw_sprite_ext(sprite_get("nspecial_eaover"), (free ? 2-image_index : image_index), x, y, spr_dir, 1, 0, c_white, 1);
    }
}


// Hitbox handling
if (get_match_setting(SET_HITBOX_VIS)) {
    if ((state == PS_ATTACK_GROUND || state == PS_ATTACK_AIR) && attack == AT_FSPECIAL) {
        if (window == 2) {
            draw_sprite_ext(sprite_get("grapple_assist_mask_" + string(spr_dir)), 0, floor(x+(gh_x_origin+gh_x_offset)*spr_dir), floor(y+gh_y_origin + gh_y_offset), 1, 1, 0, c_white, 0.5);
        }
        else if (window == 3) {
            draw_sprite_ext(sprite_get("grapple_assist_mask_" + string(spr_dir)), 0, floor(x+(gh_x_origin+gh_x_offset)*spr_dir), floor(y+gh_y_origin + gh_y_offset), 1, 1, 0, c_white, training_mode_alpha);
        }
    }
}
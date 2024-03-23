


// Arrow indicator
if (state <= 3) draw_sprite_ext(asset_get("triangle_spr"), 0, x, y-hud_offset, 1, 1, 0, get_player_hud_color(player), 1);



if (get_match_setting(SET_HITBOX_VIS) && state == 2) {
    
    draw_set_alpha(0.5)
    draw_rectangle_color(x-(trigger_w/2), y, x+(trigger_w/2), y-(trigger_h_hitstun), c_aqua, c_aqua, c_aqua, c_aqua, false);
    draw_rectangle_color(x-(trigger_w/2), y, x+(trigger_w/2), y-(trigger_h), c_fuchsia, c_fuchsia, c_fuchsia, c_fuchsia, false);
    draw_set_alpha(1);
    
}
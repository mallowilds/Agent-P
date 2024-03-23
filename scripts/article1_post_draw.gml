

if (get_match_setting(SET_HITBOX_VIS)) {
    
    // this mask doesn't seem to work anyway (lol)
    // draw_sprite_ext(sprite_get("drone_mask"), 0, x, y, spr_dir, 1, 0, c_white, 0.5);
    
}


// Arrow indicator
if (state == 1) draw_sprite_ext(asset_get("triangle_spr"), 0, x, y-hud_offset, 1, 1, 0, get_player_hud_color(player), 1);



if (player_id.object_index == oTestPlayer) exit;

// Off-screen handling

var drawing_offscreen = true;

var h_offscreen = (x > view_get_xview()+view_get_wview()) - (x < view_get_xview()); // -1 left, 1 right
var v_offscreen = (y > view_get_yview()+view_get_hview()) - (y < view_get_yview()); // -1 up, 1 down

// corners
if (h_offscreen != 0 && v_offscreen != 0) {
    
    var temp_x = view_get_xview() + (h_offscreen == -1 ? 34 : view_get_wview()-34);
    var temp_y = view_get_yview() + (v_offscreen == -1 ? 34 : view_get_hview()-34);
    
    // Starting from top-left, clockwise: 1 3 5 7
    var temp_index = (v_offscreen == -1 ? 2 : 6) - (h_offscreen * v_offscreen);
    
}

// sides
else if (h_offscreen != 0) {
    
    var temp_x = view_get_xview() + (h_offscreen == -1 ? 34 : view_get_wview()-34);
    var temp_y = y;
    
    var temp_index = (h_offscreen == -1 ? 0 : 4);
    
}

// top/bottom
else if (v_offscreen != 0) {
    
    var temp_x = x;
    var temp_y = view_get_yview() + (v_offscreen == -1 ? 34 : view_get_hview()-34);
    
    var temp_index = (v_offscreen == -1 ? 2 : 6);
    
}

else drawing_offscreen = false;



if (drawing_offscreen) {
    draw_sprite_ext(asset_get("offscreen_bg_spr"), temp_index, temp_x, temp_y, 1, 1, 0, get_player_hud_color(player), 1);
    draw_sprite(sprite_get("hud_drone"), 0, temp_x-16, temp_y-10);
}




#macro GRAPPLE_DISABLED 0
#macro GRAPPLE_ACTIVE 1
#macro GRAPPLE_RETURNING 2
#macro GRAPPLE_PLAYER_MOUNTED 3
#macro GRAPPLE_WALL_MOUNTED 4
#macro GRAPPLE_ARTICLE_MOUNTED 5

if (parachute_stats) {
    draw_sprite_ext(sprite_get("parachute"), vis_parachute_frame, x+(1*spr_dir), y-15, 1, 1, vis_parachute_angle, c_white, 1);
}

if (grapple_hook_state != GRAPPLE_DISABLED) {
    
    var temp_x_origin = (grapple_hook_state == GRAPPLE_WALL_MOUNTED || grapple_hook_state == GRAPPLE_ARTICLE_MOUNTED) ? 0 : grapple_hook_x_origin
    
    var draw_angle = point_direction(x + temp_x_origin*spr_dir, y + grapple_hook_y_origin, grapple_hook_x, grapple_hook_y);
    var draw_length = point_distance(x + temp_x_origin*spr_dir, y + grapple_hook_y_origin, grapple_hook_x, grapple_hook_y);
    
    draw_rope(sprite_get("rope"), 0, grapple_hook_x, grapple_hook_y, draw_length, draw_angle+180, c_white, 1)

    if (grapple_hook_state != GRAPPLE_PLAYER_MOUNTED) draw_angle = 90 - (90 * grapple_hook_dir);
    draw_sprite_ext(sprite_get("fspec_proj"), (grapple_hook_state != GRAPPLE_ACTIVE), grapple_hook_x, grapple_hook_y, 1, 1, draw_angle, c_white, 1);
    
}



#define draw_rope(sprite, subimg, _x, _y, _w, rot, col, _a)
    var base_width = floor(sprite_get_width(sprite));
    var cur_x = _x;
    var cur_y = _y;
    var full_loops = floor(_w / base_width);
    
    for (var i = 0; i < full_loops; i++) {
        draw_sprite_ext(sprite, subimg, cur_x, cur_y, 1, 1, rot, col, _a);
        cur_x += lengthdir_x(base_width, rot);
        cur_y += lengthdir_y(base_width, rot);
    }
    
    var cut_width = _w - (full_loops * base_width);
    var x_off = lengthdir_x(sprite_get_xoffset(sprite), rot) + lengthdir_y(sprite_get_yoffset(sprite), rot);
    var y_off = lengthdir_y(sprite_get_xoffset(sprite), rot) + lengthdir_x(sprite_get_yoffset(sprite), rot-180);
    draw_sprite_general(sprite, subimg, 0, 0, cut_width, sprite_get_height(sprite), cur_x+x_off, cur_y+y_off, 1, 1, rot, col, col, col, col, _a)
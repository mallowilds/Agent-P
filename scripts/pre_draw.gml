
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
    var draw_angle = 90 - (90 * grapple_hook_dir);
    if (grapple_hook_state == GRAPPLE_PLAYER_MOUNTED || grapple_hook_state == GRAPPLE_ARTICLE_MOUNTED) {
        draw_angle = point_direction(x + grapple_hook_x_origin*spr_dir, y + grapple_hook_y_origin, grapple_hook_x, grapple_hook_y);
    }
    
    var temp_x_origin = (grapple_hook_state == GRAPPLE_WALL_MOUNTED || grapple_hook_state == GRAPPLE_ARTICLE_MOUNTED) ? 0 : grapple_hook_x_origin
    
    if (grapple_hook_state == GRAPPLE_ACTIVE) draw_line_width_color(x + temp_x_origin*spr_dir, y + grapple_hook_y_origin, grapple_hook_x - lengthdir_x(4, draw_angle), grapple_hook_y - lengthdir_y(4, draw_angle), 8, c_white, c_white);
    draw_line_width_color(x + temp_x_origin*spr_dir, y + grapple_hook_y_origin, grapple_hook_x - lengthdir_x(4, draw_angle), grapple_hook_y - lengthdir_y(4, draw_angle), 4, c_black, c_black);
    draw_sprite_ext(sprite_get("fspec_proj"), (grapple_hook_state != GRAPPLE_ACTIVE), grapple_hook_x, grapple_hook_y, 1, 1, draw_angle, c_white, 1);
    
}
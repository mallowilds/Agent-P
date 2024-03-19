// debug text, add more if need be
/*if "should_debug" in self {
    if (should_debug) {
        draw_debug_text(temp_x - 70, temp_y - 90, "Previous State: "+get_state_name(prev_state));
        draw_debug_text(temp_x - 70, temp_y - 75, "State: "         +get_state_name(state));
        draw_debug_text(temp_x - 70, temp_y - 60, "State Timer: "   +string(state_timer));
        draw_debug_text(temp_x - 70, temp_y - 45, "Attack: "        +string(attack));
        draw_debug_text(temp_x - 70, temp_y - 30, "Window: "        +string(window));
        draw_debug_text(temp_x - 70, temp_y - 15, "Window Timer: "  +string(window_timer));
        draw_debug_text(temp_x + 70, temp_y - 45, "HSP: "   +string(round(hsp)));
        draw_debug_text(temp_x + 70, temp_y - 30, "VSP: "   +string(round(vsp)));
        draw_debug_text(temp_x + 70, temp_y - 15, "Image Index: "   +string(image_index));
    }
}
*/

var drone_spr = sprite_get("hud_drone");

var h1 = sprite_get_height(drone_spr) * (nspec_drone_cd[1] / nspec_drone_cd_max)
var y1 = sprite_get_height(drone_spr) - h1;
draw_sprite(drone_spr, 0, temp_x+178, temp_y-16);
draw_sprite_part_ext(drone_spr, 0, 0, y1, sprite_get_width(drone_spr), h1, temp_x+178, temp_y-16+y1, 1, 1, c_black, 0.5);

var h0 = sprite_get_height(drone_spr) * (nspec_drone_cd[0] / nspec_drone_cd_max)
var y0 = sprite_get_height(drone_spr) - h0;
draw_sprite(drone_spr, 0, temp_x+174, temp_y-20);
draw_sprite_part_ext(drone_spr, 0, 0, y0, sprite_get_width(drone_spr), h0, temp_x+174, temp_y-20+y0, 1, 1, c_black, 0.5);

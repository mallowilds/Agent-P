//                      --APPLYING COLOR SHADE CHANGES--                      //
/* // WIP
if "num_base_colors" in self {
for (var i=0; i < num_base_colors; i++) {
    set_character_color_shading(i, col_shade_list[get_player_color(player)][i]);
}
}
*/

// i.e. if disguised (see unload.gml)
if get_synced_var(player) {
    if (object_index == asset_get("draw_result_screen")) {
        winner_name = "PERRY THE PLATYPUS WINS!";
    }
}
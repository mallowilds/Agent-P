//                      --APPLYING COLOR SHADE CHANGES--                      //
/* // WIP
if "num_base_colors" in self {
for (var i=0; i < num_base_colors; i++) {
    set_character_color_shading(i, col_shade_list[get_player_color(player)][i]);
}
}
*/
var col = get_player_color( player ) 

// i.e. if disguised (see unload.gml)
if get_synced_var(player) {
    if (object_index == asset_get("draw_result_screen")) {
        winner_name = "PERRY THE PLATYPUS WINS!";
    }
}

if col == 6 || col == 13 || col == 14 {
    for (var slot_num = 0; slot_num < 8; slot_num++) {
    set_character_color_shading( slot_num, 0 );
    }
}


switch col {
    case 6:
        outline_color = [42, 90, 63]; 
    break;
    case 13: {
        outline_color = [255, 255, 255]
    }
    break;
}
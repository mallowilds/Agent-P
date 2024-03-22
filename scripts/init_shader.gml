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

if col == 6  {
    for (var slot_num = 0; slot_num < 8; slot_num++) {
    set_character_color_shading( slot_num, 0 );
    }
}


switch col {
    case 0: 
        set_character_color_slot( 7, 255, 255, 255 )
        set_article_color_slot( 7, 255, 255, 255 )
        break;
    case 6:
        outline_color = [42, 90, 63]; 
    break;
    case 13: {
        set_character_color_shading( 2, 0 );
        set_character_color_shading( 3, 0 );
        set_character_color_shading( 4, 0 );
        set_character_color_shading( 6, 0 );
        set_character_color_shading( 7, 0 );
    }
    break;
}
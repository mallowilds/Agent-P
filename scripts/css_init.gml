// Recreation of the core functionality of Hyu's css template -- by Nart
qe = "ziggy" // updating this variable so that others can still use this char to reload their hyu css template

timer = 0;
timer_max = 90;

alt_cur = get_player_color(player);
alt_old = alt_cur;
alt_dir = 0;

alt_max = 12; // number of alternate color palettes, not including default

// Alt info
alt_info[0,0] = get_color_slot_hex(0, 3);
alt_info[0,1] = "Agent P";

alt_info[1,0] = get_color_slot_hex(1, 3);
alt_info[1,1] = "Agent B";

alt_info[2,0] = get_color_slot_hex(2, 3);
alt_info[2,1] = "Agent C";

alt_info[3,0] = get_color_slot_hex(3, 3);
alt_info[3,1] = "Agent T";

alt_info[4,0] = get_color_slot_hex(4, 3);
alt_info[4,1] = "Agent N";

alt_info[5,0] = get_color_slot_hex(5, 3);
alt_info[5,1] = "Agent V";

alt_info[6,0] = get_color_slot_hex(6, 3);
alt_info[6,1] = "Pilot";

alt_info[7,0] = get_color_slot_hex(7, 3);
alt_info[7,1] = "Other Dimension";

alt_info[8,0] = get_color_slot_hex(8, 3);
alt_info[8,1] = "Agent... Meap?";

alt_info[9,0] = get_color_slot_hex(9, 3);
alt_info[9,1] = "Agent Pond";

alt_info[10,0] = get_color_slot_hex(10, 3);
alt_info[10,1] = "Fearless";

alt_info[11,0] = get_color_slot_hex(11, 3);
alt_info[11,1] = "Courageous";

alt_info[12,0] = get_color_slot_hex(12, 3);
alt_info[12,1] = "Ravenous";

alt_info[13,0] = get_color_slot_hex(13, 3);
alt_info[13,1] = "Canon";


// MISC. STUFF
online_css = (player == 0);
//alt_rainbow = 27;

#define get_color_slot_hex(alt, slot)
var _r = get_color_profile_slot_r(alt, slot);
var _g = get_color_profile_slot_g(alt, slot);
var _b = get_color_profile_slot_b(alt, slot);
return make_color_rgb(_r, _g, _b);


#define get_seasonal_name
var name;
switch (get_match_setting(SET_SEASON)) {
    case 1: name = "Valentine's"; break;
    case 2: name = "Summer"; break;
    case 3: name = "Halloween"; break;
    case 4: name = "Christmas"; break;
}
return name;


//a

//reset number of windows in case of a grab
reset_attack_value(attack,AG_NUM_WINDOWS);

if (attack == AT_DSPECIAL  && free) attack = AT_DSPECIAL_AIR

if (attack == AT_TAUNT && down_down) attack = AT_TAUNT_2;

// Prevent ustrong from flying off ledges (immediately is reset to 2)
if (attack == AT_USTRONG) set_attack_value(AT_USTRONG, AG_CATEGORY, 0);

// Block NSpec if all drone cds are active
if (attack == AT_NSPECIAL && nspec_drone_cd >= nspec_max_drones*nspec_drone_cd_max) {
    move_cooldown[AT_NSPECIAL] = 2;
}



// detect/apply once-per-air limit to attacks
if (get_attack_value(attack,AG_ATTACK_AIR_LIMIT)) {
    if (attack_air_limit[attack] && move_cooldown[attack] < 2) {
        move_cooldown[attack] = 2;
    } else {
        attack_air_limit[attack] = true;
        attack_air_limit_ver = true;
    }
}

// reset grab variables on new attack
// if your grab uses different attack indexes, you may want to add additional
// checks to prevent accidental grab releases
grabbed_player_obj = noone; 
grabbed_player_relative_x = 0;
grabbed_player_relative_y = 0;



if (attack == AT_TAUNT && down_down) {
   if shield_down {
    attack = AT_INTRO_1
} else {
    attack = AT_TAUNT_2;
}
}


//if (attack == AT_TAUNT && down_down) attack = AT_TAUNT_2;
//debug, restore this vers after trailer clip is made

if (attack == AT_DSPECIAL  && free) attack = AT_DSPECIAL_AIR
/* debug
if (attack == AT_JAB) {
    if ground_type == 1 {
        attack = AT_INTRO_1
        print("1")
    } else {
        attack = AT_INTRO_2
        print("2")
    }
}*/ 
// Prevent ustrong from flying off ledges (immediately is reset to 2)
if (attack == AT_USTRONG) set_attack_value(AT_USTRONG, AG_CATEGORY, 0);

// Block NSpec if all drone cds are active
if (attack == AT_NSPECIAL && nspec_drone_cd >= nspec_max_drones*nspec_drone_cd_max) {
    move_cooldown[AT_NSPECIAL] = 2;
}

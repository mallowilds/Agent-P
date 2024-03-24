//a

//reset number of windows in case of a grab
reset_attack_value(attack,AG_NUM_WINDOWS);

if (attack == AT_DSPECIAL && free) attack = AT_DSPECIAL_AIR

if (attack == AT_TAUNT && down_down) attack = AT_TAUNT_2;

// Prevent ustrong from flying off ledges (immediately is reset to 2)
if (attack == AT_USTRONG) set_attack_value(AT_USTRONG, AG_CATEGORY, 0);

// Block NSpec if all drone cds are active
if (attack == AT_NSPECIAL && nspec_drone_cd >= nspec_max_drones*nspec_drone_cd_max) {
    move_cooldown[AT_NSPECIAL] = 2;
}

// Air attack limits
if (attack == AT_USPECIAL && uspec_used) move_cooldown[AT_USPECIAL] = 2;
if (attack == AT_FSPECIAL && (fspec_used || grapple_hook_state != 0)) move_cooldown[AT_FSPECIAL] = 2;
if (attack == AT_DSPECIAL_AIR && dspec_used) move_cooldown[AT_DSPECIAL_AIR] = 2;



//debug, restore this vers after trailer clip is made
if (attack == AT_TAUNT && shield_down) attack = AT_INTRO_1;

if (attack == AT_TAUNT && down_down) attack = AT_TAUNT_2;


if (attack == AT_DSPECIAL && free) attack = AT_DSPECIAL_AIR;


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

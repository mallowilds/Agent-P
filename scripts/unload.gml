if state == PS_CROUCH || (state == PS_ATTACK_GROUND && attack == AT_TAUNT_2) || (state == PS_ATTACK_GROUND && attack == AT_DTILT) || (state == PS_ATTACK_GROUND && attack == 49) {
    disguised = 1;
   // print("p")
    set_victory_portrait(sprite_get("portrait_perry"));
}

if (parachute_active) {
    parachute_active = false;
    var despawn_parachute = instance_create(x+(1*spr_dir), y-15, "obj_article3");
    despawn_parachute.state = 00;
}

if (attack == AT_USTRONG && instance_exists(ustrong_smear)) {
    ustrong_smear.step_timer = 99; // destroy
}

// disable grappling hook
grapple_hook_state = 0; // GRAPPLE_DISABLED
if (instance_exists(grapple_hook_hitbox)) {
    grapple_hook_hitbox.destroyed = true;
    grapple_hook_hitbox = noone;
}
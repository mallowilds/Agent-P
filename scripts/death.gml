
parachute_active = false;

// disable grappling hook
grapple_hook_state = 0; // GRAPPLE_DISABLED
if (instance_exists(grapple_hook_hitbox)) {
    grapple_hook_hitbox.destroyed = true;
    grapple_hook_hitbox = noone;
}

// despawn drones
with obj_article1 {
    if (player_id == other && state <= 1) {
        state = 2;
        state_timer = 0;
    }
}
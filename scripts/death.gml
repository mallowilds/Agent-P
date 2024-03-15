
parachute_active = false;

// disable grappling hook
grapple_hook_state = 0; // GRAPPLE_DISABLED
if (instance_exists(grapple_hook_hitbox)) {
    grapple_hook_hitbox.destroyed = true;
    grapple_hook_hitbox = noone;
}

var atk = my_hitboxID.attack
var hbox = my_hitboxID.hbox_num

// Insert obvious pun

if (parachute_active) {
    parachute_active = false;
    var despawn_parachute = instance_create(x+(1*spr_dir), y-15, "obj_article3");
    despawn_parachute.state = 00;
}

if (atk == AT_FSPECIAL && hbox == 1 && my_hitboxID.orig_player == player) {
    was_parried = 1;
    grapple_hook_hitbox = noone;
}

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
    my_hitboxID.destroyed = true;
    grapple_hook_hitbox = noone;
}

if (atk == AT_DSTRONG && my_hitboxID.orig_player == player) {
    if (hit_player_obj == self) {
        dstrong_cancel_parry_stun = (get_gameplay_time() != dstrong_parried_time);
    }
    else {
        dstrong_parried_time = get_gameplay_time(); // resolves potential script order conflict
        dstrong_cancel_parry_stun = false;
    }
}

if (atk == AT_NSPECIAL && hbox == 1 && my_hitboxID.hit_priority == 5) {
    
    instance_destroy(my_hitboxID.owner_drone);
    nspec_num_drones--;
    
    var reflection = create_hitbox(AT_NSPECIAL, 2, my_hitboxID.x, my_hitboxID.y);
    reflection.was_parried = true;
    reflection.last_player_id = hit_player_obj;
    reflection.player = hit_player;
    
    var dir = point_direction(my_hitboxID.x, my_hitboxID.y, x, y);
    reflection.hsp = lengthdir_x(9, dir);
    reflection.vsp = lengthdir_y(9, dir);
    
    print_debug(reflection.x);
    print_debug(reflection.y);
    
}
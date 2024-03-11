//a
state_timer += 1;

switch(state) { // use this one for doing actual article behavior
    case 0: // spawn
        if (state_timer == 25) { // go to idle state after 25 frames
            set_state(1);
        }
        break;
    case 1: // idle
        if (state_timer == 10000000) { // go to dead state after 50 frames
            set_state(2);
        }
        break;
    case 2: //die
        if (state_timer == 20) { // die after 20 frames
            should_die = true;
        }
        break;
}

switch(state) { // use this one for changing sprites and animating
    case 0: // spawn
        image_index = (state_timer / 4) % 4;
        break;
    case 1: // idle
        image_index = 4 + (state_timer / 4) % 12;
        break;
    case 2: //die
        image_index = (state_timer / 4) % 4;
        break;
}
// don't forget that articles aren't affected by small_sprites

if (should_die) { //despawn and exit script
    instance_destroy();
    exit;
}


#define set_state
var _state = argument0;
state = _state;
state_timer = 0;
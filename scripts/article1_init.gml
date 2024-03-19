//                              ARTICLE  STUFF                                //
/*
    considering that articles are p much empty things that you can do whatever
    with, I'll only set up a really basic state machine since those tend to be 
    pretty useful for most situations
    
    although sometimes you'll probably want to delete it and start from scratch
    if it's a really simple article
*/

// sprite and mask indexes; + default article variables
sprite_index = sprite_get("drone");
mask_index = asset_get("drone_mask");
can_be_grounded = false;
ignores_walls = true;
spr_dir = player_id.spr_dir;

uses_shader = true;

// state machine variables
state = 0;
state_timer = 0;
should_die = false; //if the article should be despawned

throw_dir = 0; // default

max_lifetime = 900;
lifetime_decay_step = 9; // applied per frame while grappled, in addition to the standard lifetime progress
lifetime_decayed = 0;
last_decay_frame = get_gameplay_time(); // ensures only one decay step per frame

hit_angle = 0;

// grapple compat
agent_p_grapplable = 2;     // denotes grabbability by grappling hook. 
                            // (2 is a special value denoting the drone, use 1 or true for article compat)
agent_p_pull_vel = 0.5;     // how much grappling should move the article by (set to 0 to disable)
agent_p_grappling = false;  // set to true each frame grapple is applied.
                            // (should be set to false at the end of article update.)
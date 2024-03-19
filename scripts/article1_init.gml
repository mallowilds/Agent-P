//                              ARTICLE  STUFF                                //

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

// grapple compat
agent_p_grapplable = 2;     // denotes grabbability by grappling hook. 
                            // (2 is a special value denoting the drone, use 1 or true for article compat)
agent_p_pull_vel = 0.5;     // how much grappling should move the article by (set to 0 to disable)
agent_p_grappling = false;  // set to true each frame grapple is applied.
                            // (should be set to false at the end of article update.)
agent_p_grapple_dir = 0;    // pull direction for ongoing grapple. used for visual updates.



// Supersonic Hit Detection Template
 
//make hbox_group array (the old version was really bad because the array actually affected all players no matter what lol)
hbox_group = array_create(4,0);
var i1 = 0;
var i2 = 0;
repeat(4) {
    hbox_group[@i1] = array_create(50,0);
    repeat(50) {
        hbox_group[@i1][@i2] = array_create(10,0);
        i2++;
    }
    i2 = 0;
    i1++;
}
 
hitstun = 0;
hitstun_full = 0;
 
kb_adj = 1;
kb_dir = 0;
orig_knock = 0;
 
hit_lockout = 0;
 
article_should_lockout = true; //set to false if you don't want hit lockout.
 
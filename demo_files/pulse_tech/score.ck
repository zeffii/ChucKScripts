[
[1,0,0,0, 1,0,0,0],
[0,0,0,0, 1,0,0,0]
] @=> int perc_pat[][];

// percssion setups
BKick2 kick;
kick.mout => dac;
kick.patch(1);

BSnareOne snare;
snare.mout => ADSR snareShape => LPF duff => dac;
duff.freq(7700);
snare.set_speed(2.63);
snare.adssr(6::ms, 63::ms, 10::ms, 110::ms, 0.5);
snare.patch(1);
snare.set_vol_env([0., 1, 0.,  0.18, 0.32, .7,  1, 0.2]);
snareShape.set( 2::ms, 371::ms, 0.1, 15::ms );  //a, d, s, r

8 => int num_ticks;
repeat(4){
    for(0 => int i; i<num_ticks; i++){
        perc_pat[0][i] => do_kick;
        perc_pat[1][i] => do_snare;
        140::ms => now;
    }
}

fun void do_kick(int tval){
    if (tval==1) kick.trigger(.5);
}

fun void do_snare(int tval){
    if (tval==1) {
        snareShape.keyOn();
        snare.trigger(.41);
    }
}

// edit -w  
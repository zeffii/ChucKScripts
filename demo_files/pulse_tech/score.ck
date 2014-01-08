[
[1,0,0,0, 0,0,0,0, 0,0,1,0, 0,0,0,0],
[0,0,0,0, 1,0,0,0, 0,0,0,0, 1,0,0,0]
] @=> int perc_pat[][];

[
25, 0, 0,  
21, 0, 0, 
35, 0, 0, 
32, 0, 0,
34, 0, 20,
22] @=> int sounds[];

// percssion setups
BKick2 kick;
kick.mout => dac;
kick.patch(1);

BSnareOne snare;
snare.mout => ADSR snareShape => LPF duff => dac;
duff.freq(9700);
snare.set_speed(2.33);
snare.adssr(6::ms, 63::ms, 10::ms, 110::ms, 0.5);
snare.patch(1);
snare.set_vol_env([0., 1, 0.,  0.18, 0.32, .7,  1, 0.2]);
snareShape.set( 2::ms, 281::ms, 0.1, 15::ms );  //a, d, s, r

BSnareOne snare2;
snare2.mout => ADSR snareShape2 => LPF duff2 => dac;
duff2.freq(3800);
snare2.set_speed(1.03);
snare2.adssr(6::ms, 143::ms, 30::ms, 110::ms, 0.5);
snare2.patch(1);
snare2.set_vol_env([0., 1, 0.,  0.32, 0.42, .7,  1, 0.2]);
snareShape2.set( 2::ms, 241::ms, 0.0, 15::ms );  //a, d, s, r

SinOsc modulator => SinOsc carrier => Mix2 sout => ADSR cEnv => dac;
cEnv.set( 12::ms, 141::ms, 0.70, 35::ms );  //a, d, s, r

16 => int num_ticks;
repeat(4){
    for(0 => int i; i<num_ticks; i++){
        perc_pat[0][i] => do_kick;
        perc_pat[1][i] => do_snare;
        sounds[i] => do_bassline; 
        100::ms => now;
    }
}

fun void do_bassline(int tval){
    if (tval == 0) return;

    tval => Std.mtof => float freqw => carrier.freq;
    freqw*2 => modulator.freq;
    carrier.sync(2);
    sout.gain(0.3);
    modulator.gain(300);

    cEnv.keyOn();
}

fun void do_kick(int tval){
    if (tval==1) kick.trigger(.5);
}

fun void do_snare(int tval){
    if (tval==1) {
        mixed_snare(tval);
    }
}

fun void mixed_snare(int tval){
    snareShape.keyOn();
    snare.trigger(.35);    
    snareShape2.keyOn();
    snare2.trigger(.61);        
}


// edit -w  


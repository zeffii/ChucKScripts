PolySynth polysyn;

NRev reverb_synth[2];
reverb_synth[0].mix(0.013);
reverb_synth[1].mix(0.013);

polysyn.out.left => reverb_synth[0] => dac.left;
polysyn.out.right => reverb_synth[1] => dac.right;

//synth.max_gain(0.2);

[1, 1, 0, 0,   1, 1, 0, 0,   1, 1, 0, 0,   0, 0, 0, 0,  1, 1, 0, 0,   0, 0, 0, 0,  1, 1, 0, 0,   0, 0, 0, 0] @=> int pseq[];


repeat(1){

    for(0 => int i; i<pseq.cap(); i++){
        if ( pseq[i] == 1){
            polysyn.play_synth([42,42], 1900.0, .9, .7);
        }
        0.12::second => now;
    }

    for(0 => int i; i<pseq.cap(); i++){
        if ( pseq[i] == 1){
            polysyn.play_synth([40,40], 1900.0, .9, .7);
        }
        0.12::second => now;
    }
}





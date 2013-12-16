PolyWaveForm synth;

NRev reverb_synth[2];
synth.set_gain(0.11);
synth.sum_waveforms.left => reverb_synth[0] =>  dac.left;
synth.sum_waveforms.right => reverb_synth[1] => dac.right;

reverb_synth[0].mix(0.033);
reverb_synth[1].mix(0.033);

//synth.max_gain(0.2);
[50,54,57,59] @=> int notes[];

[1, 0, 0, 1,   0, 0, 1, 0,   1, 0, 0, 1,   0, 0, 1, 0] @=> int pseq[];

repeat(4){

    for(0 => int i; i<pseq.cap(); i++){
        if ( pseq[i] == 1){
            //synth.play_chord(notes, 0, 100, Math.random2f(0.0, 8.0));
            synth.play_chord(notes, 0, 100, Math.random2f(0.0, 2.0));
        }

        0.14::second => now;
    }
}
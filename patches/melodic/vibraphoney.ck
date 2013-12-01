Gain vibGain => dac;

vibGain.gain(4.0);

[46, 48, 49, 51, 53, 54, 56, 58] @=> int scale[];

repeat(3){
    for(0 => int i; i < scale.cap(); i++)
    {    
       <<< i >>>;
       scale[i] => int note;
       spork ~ play_vibra(note);
       .2::second => now;
    }
}

fun void play_vibra(int note){

    ModalBar modalBar => ADSR vibEnv => vibGain;
    320 => modalBar.vibratoFreq;
    6 => modalBar.preset;

                        //int, float (0.0 128.0)
    modalBar.controlChange(2, 123.0);   // - Stick Hardness
    modalBar.controlChange(4, 27.0);    // - Stick Position
    modalBar.controlChange(11, 53.0);  // - Vibrato Gain 
    modalBar.controlChange(7, 115.0);   // - Vibrato Frequency
    modalBar.controlChange(1, 0.01);   // - Direct Stick Mix
    modalBar.controlChange(128, 0.2); // - Volume

    vibEnv.set( 42::ms, 371::ms, 0.80, 35::ms );  //a, d, s, r
    vibEnv.keyOn();
    Std.mtof(note)*2 => modalBar.freq;
    1.0 => modalBar.noteOn; 
    .75 => modalBar.strike;
    1.4::second => now;

    modalBar =< vibGain;

}

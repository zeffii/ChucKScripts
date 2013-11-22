// bassdrum synthesis
// Dealga McArdle, Nov 2013
SawOsc spitch => SinOsc bd_osc => 
Gain preAmp => ADSR bdADSR => Gain master => dac;

1.2 => master.gain;
20 => bd_osc.freq;
162.02 => spitch.gain;
2 => bd_osc.sync;
.7 => preAmp.gain;

fun void BD1_ON(float pgain){
    bdADSR.set( 2::ms, 181::ms, 0.0, 35::ms );
    pgain => preAmp.gain;
    -1.0 => spitch.phase;
    .5 => spitch.sfreq;    
    bdADSR.keyOn();
}

BD1_ON(.7);
0.75::second => now;


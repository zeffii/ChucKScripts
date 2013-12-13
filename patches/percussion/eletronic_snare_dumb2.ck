Mix2 mout => Dyno dyno => ADSR masterEnv => dac;
SinOsc sin1 => ADSR oscEnv1 => mout;
SinOsc sin2 => ADSR oscEnv2 => mout;
SinOsc detune => ADSR detuneEnv => sin2;
SawOsc detune2 => sin1;
Noise noise1 => LPF filt1_lp => ADSR lpfEnv => mout;
Noise noise2 => HPF filt2_hp => ADSR hpfEnv => mout;
2 => sin1.sync;
2 => sin2.sync;
mout.gain(0.5);

dyno.compress();
dyno.thresh(0.05);
dyno.ratio(0.4);

fun void trigger(float tune, int decay, int brightness, float snappy){

    masterEnv.set( 2::ms, (decay*17.7)::ms, 0.00, 0::ms );  //a, d, s, r
    masterEnv.gain(.15);
    masterEnv.keyOn();

    // detune of osc
    detuneEnv.set( 2::ms, decay*2::ms, 0.0, 0::ms );  //a, d, s, r
    detuneEnv.keyOn();
    6.42 => detune.freq;
    detune.gain(56.0);
    tune => sin1.freq;
    tune => sin2.freq;
    detune2.gain(222.0);
    detune2.freq(0.16);
    
    // two oscillator setup

    sin1.gain(.8);
    sin2.gain(.7);
    sin1.phase(pi);
    sin2.phase(pi);
    oscEnv1.set( 2::ms, decay*0.7::ms, 0.00, 35::ms );  //a, d, s, r
    oscEnv2.set( 2::ms, decay::ms, 0.00, 35::ms );  //a, d, s, r
    oscEnv1.keyOn();
    oscEnv2.keyOn();

    // noise lowpass
    lpfEnv.set( 2::ms, (decay/.317)::ms, 0.00, 35::ms );  //a, d, s, r
    lpfEnv.keyOn();
    brightness => filt1_lp.freq;

    // noise lowpass
    if (snappy > 1.0) 1.0 => snappy;
    220 => filt2_hp.freq;
    2.7 => filt2_hp.Q;
    snappy => noise2.gain;
    hpfEnv.set( 19::ms, (decay*7.25)::ms, 0.00, 35::ms );  //a, d, s, r
    hpfEnv.keyOn();

    

    // pass time.
    decay*5::ms => now;
    // oscEnv1.keyOff();
    // oscEnv2.keyOff();
    // lpfEnv.keyOff();
    // hpfEnv.keyOff();

}

trigger(70.0, 90, 230, .6);

1::second => now;


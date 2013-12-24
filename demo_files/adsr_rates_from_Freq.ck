// patch
SinOsc s => Gain pre => Gain post => dac;
post.gain(0.2);
740. => s.freq;

// spork ~ adsr_plus(1.2::second, pre, 64::ms);  // terrible, 
// spork ~ adsr_plus(1.2::second, pre, 1::ms);  // acceptable? maybe for some signals
spork ~ adsr_plus(1.2::second, pre, 240);  // acceptable? maybe for fast computers.


3::second => now;


fun void adsr_plus(dur total_duration, Gain this_volume, int freq){

    CurveTable c;
    [0., 0., -1.75, 1., 1., 0.5, 3., 0.] => c.coefs;

    // create an envelope to scan through the table values
    Envelope e => blackhole;
    e.duration(total_duration);
    e.keyOn(); //ramp to 1 in total_duration

    1::second / freq => dur ctrl_rate;

    now => time start;
    start + total_duration => time end;
    while(now < end){
        c.lookup(e.value()) => this_volume.gain; 
        ctrl_rate => now;
        //1::samp => now;
    }
    0 => this_volume.gain;
    
}


// this one is a bit more versatile:

public class PercSynC{

    0.0 => float mgain;
    Gain bdmast;
    bdmast.gain(mgain);

    int start_pitch;
    int vduration;

    fun void trigger(float volume, int len, int ffreq){
        2290 => this.start_pitch;
        len => this.vduration;
        this.bdmast.gain(volume/4.3);
        spork ~ s_segment(ffreq);
    }

    fun void s_segment(int filter_freq){

        CurveTable c;

        // in essence this array says.
        [0., start_pitch, -7.98,    // at 0 use start_pitch, -7.98 [curve steepness]
        0.05, 240, -.98,            // at 0.05 already be at 240 
        .17, 114, 0,                // at 0.17 reach 114
        .61, 54, 0,                 // at 0.61 be at 54
        1.8, 41.] => c.coefs;       // 1.8 is unitless duration of all of this

        // frequency curve
        ADSR e => blackhole;
        e.set( 0::ms, 340::ms, 0.0, 125::ms );  //a, d, s, r
        e.keyOn(1); 

        // simple adsr
        ADSR volE;
        volE.set( 0::ms, vduration::ms, 0.0, 65::ms );  //a, d, s, r
        volE.keyOn();

        // routing.
        c => blackhole;
        Dyno comp => bdmast;
        comp.compress();
        Noise form => volE => LPF boom => PoleZero dc => comp; 
        dc.blockZero(0.594);
        filter_freq => boom.freq;


        // set

        now => time start;
        // ready
        while (true)
        {
            Math.fabs(c.lookup(1/e.value())) $ int => int dump;

            if (dump < 0) start_pitch => dump;
            1 - (1/dump) => form.gain;

            boom.Q(2.26);
            21::samp => now;

            // advance time
            if (now > (start + vduration::ms)){
                e.keyOff();
                volE.keyOff();
                break;
            }
        }
 
        1::second => now;
    }

}


PercSynC perc1;

perc1.bdmast => dac;
perc1.bdmast => NRev blunk2 => dac;
blunk2.gain(0.01);
blunk2.mix(0.2);

for(0 => int i; i<5; i++){
    perc1.trigger(1.4, 43, 7232);
    0.5::second => now;
}


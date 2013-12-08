public class PercSynC{

    0.0 => float mgain;
    Gain bdmast;
    bdmast.gain(mgain);

    int start_pitch;

    fun void trigger(float volume){
        1590 => this.start_pitch;
        this.bdmast.gain(volume/3.3);
        spork ~ s_segment();
    }

    fun void s_segment(){

        CurveTable c;
        [0., start_pitch, -7.98,  
        0.05, 240, -.98,  
        .17, 114, 0, 
        .61, 54, 0, 
        1.8, 41.] => c.coefs;

        // frequency curve
        ADSR e => blackhole;
        e.set( 0::ms, 740::ms, 0.0, 125::ms );  //a, d, s, r
        e.keyOn(1); 

        // simple adsr
        ADSR volE;
        volE.set( 0::ms, 281::ms, 0.0, 65::ms );  //a, d, s, r
        volE.keyOn();

        // routing.
        c => blackhole;
        Dyno comp => bdmast;
        comp.compress();
        Noise form => volE => LPF boom => PoleZero dc => comp; 
        dc.blockZero(0.494);
        1432 => boom.freq;


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
            if (now > (start + 280::ms)){
                e.keyOff();
                volE.keyOff();
                break;
            }
        }
 
        1::second => now;
    }

}

/*
Usage doc

    PercSynC perc1;

    perc1.bdmast => dac;
    perc1.bdmast => NRev blunk2 => dac;
    blunk2.gain(0.01);
    blunk2.mix(0.2);

    for(0 => int i; i<5; i++){
        perc1.trigger(4.4);
        0.5::second => now;
    }

*/

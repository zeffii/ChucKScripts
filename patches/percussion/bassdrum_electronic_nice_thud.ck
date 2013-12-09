// I would appreciate if you would link to this source if you use this patch.

public class KickSynC{

    0.0 => float mgain;
    Gain bdmast;
    bdmast.gain(mgain);

    fun void trigger(float volume){
        this.bdmast.gain(volume/4.1);
        spork ~ s_do_kick();
    }

    fun void s_do_kick(){

        CurveTable c;
        [0., 1590, -7.98,  
        0.017, 440, -.98,  
        0.05, 140, -.98,  
        .17, 114, 0, 
        .61, 54, 0, 
        1.8, 41.] => c.coefs;

        // frequency curve
        ADSR e => blackhole;
        e.set( 0::ms, 460::ms, 0.0, 125::ms );  //a, d, s, r
        e.keyOn(1); 

        // simple adsr
        ADSR volE;
        volE.set( 0::ms, 221::ms, 0.0, 65::ms );  //a, d, s, r
        volE.keyOn();

        // routing.
        c => blackhole;
        Dyno comp => bdmast;
        comp.compress();
        SinOsc form => volE => LPF boom => PoleZero dc => comp; 
        dc.blockZero(0.994);
        1222 => boom.freq;


        // set

        now => time start;
        // ready
        while (true)
        {
            c.lookup(1/e.value()) $ int => form.freq;
            boom.Q(.26);
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
    Usage docs

    KickSynC kick1;

    kick1.bdmast => dac;
    kick1.bdmast => NRev blunk => dac;
    blunk.gain(0.01);
    blunk.mix(0.2);

    for(0 => int i; i<5; i++){
        kick1.trigger(4.4);
        0.5::second => now;
    }
*/

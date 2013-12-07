// Assignment 7 drumCircleDSP
public class KickSynC{

    0.0 => float mgain;
    Gain bdmast;
    bdmast.gain(mgain);

    fun void trigger(float volume){
        this.bdmast.gain(volume);
        spork ~ s_do_kick();
    }

    fun void s_do_kick(){

        CurveTable c;
        [0., 310, -.98,  1.0,50,-.6, 11.0, 1.] => c.coefs;

        // frequency curve
        ADSR e => blackhole;
        e.set( 0::ms, 621::ms, 0.0, 135::ms );  //a, d, s, r
        e.keyOn(1); 

        // simple adsr
        ADSR volE;
        volE.set( 0::ms, 181::ms, 0.0, 65::ms );  //a, d, s, r
        volE.keyOn();

        // routing.
        c => blackhole;
        SinOsc form => volE => LPF boom => PoleZero dc => bdmast; 
        dc.blockZero(0.992);
        70 => boom.freq;


        // set

        now => time start;
        // ready
        while (true)
        {
            c.lookup(1/e.value()) $ int => form.freq;
            boom.Q(1.3);
            41::samp => now;

            // advance time
            if (now > (start + 170::ms)){
                e.keyOff();
                volE.keyOff();
                break;
            }
        }
 
        1::second => now;
    }

}

KickSynC kick1;

kick1.bdmast => dac;
kick1.trigger(1.3);

1::second => now;


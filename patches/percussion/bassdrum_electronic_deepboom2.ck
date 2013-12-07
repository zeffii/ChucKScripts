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
        [0., 970, -5.98,  .24, 104,-3.3, 1.8, 41.] => c.coefs;

        // frequency curve
        ADSR e => blackhole;
        e.set( 0::ms, 540::ms, 0.0, 125::ms );  //a, d, s, r
        e.keyOn(1); 

        // simple adsr
        ADSR volE;
        volE.set( 0::ms, 281::ms, 0.0, 65::ms );  //a, d, s, r
        volE.keyOn();

        // routing.
        c => blackhole;
        Dyno comp => bdmast;
        comp.compress();
        SinOsc form => volE => LPF boom => PoleZero dc => comp; 
        dc.blockZero(0.994);
        132 => boom.freq;


        // set

        now => time start;
        // ready
        while (true)
        {
            c.lookup(1/e.value()) $ int => form.freq;
            boom.Q(.22);
            21::samp => now;

            // advance time
            if (now > (start + 250::ms)){
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
kick1.trigger(4.4);

1::second => now;


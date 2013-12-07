// Assignment 7 drumCircleDSP

public class KickSynC{

    Gain bdmaster2 => dac;
    bdmaster2.gain(0.02);

    fun void trigger(float volume){
        /* this makes it possible to trigger 
        the bassdrum in a new thread */
        spork ~ s_do_kick(volume);
    }

    fun void s_do_kick(float volume){

        3850 => float frequency;

        SinOsc bd_osc => 
        Gain preAmp => HPF bf => ADSR volEnv => 
        PoleZero dc => LPF highs => bdmaster2;
        
        dc.blockZero(0.99);
        bf.freq(50);
        bf.Q(4.1);
        highs.freq(332);
        
        volEnv.set( 1::ms, 181::ms, 0.3, 35::ms );
        bdmaster2.gain(volume);

        1 => int fa;
        44 => int fd;
        50 => int fs;
        120 => int fr;

        44100/frequency => float grain;

        Step s5 => ADSR pitchEnv => blackhole;
        pitchEnv.set(fa::ms, (fd/1.2)::ms, fs/100, fr::ms);
        pitchEnv.keyOn(1);
        volEnv.keyOn(1);
        (140)::ms + now => time later;
        while(now < later)
        {
            850 => int min_freq;
            51 => int bass_freq;
            ((pitchEnv.last()*220) + min_freq) $ int => int pitch_curve;
            Math.max(pitch_curve, bass_freq) - 800.0 => float debug_freq => bd_osc.freq;

            grain::samp => now;

            if( now > later){
                (120)::ms => now;
                volEnv.keyOff(1);
                pitchEnv.keyOff(1);
            }
        }



        1.5::second => now;
        bd_osc =< preAmp;

    }

}

KickSynC kick1;

kick1.trigger(0.5);

1::second => now;

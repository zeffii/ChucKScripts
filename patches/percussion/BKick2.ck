public class BKickONE {

    Mix2 mout;
    dur a, d, s, r;
    float slevel;
    float vol;
    float c[];

    fun void adssr(dur a, dur d, dur s, dur r, float slevel){
        a => this.a;
        d => this.d;
        s => this.s;
        r => this.r;
        slevel => this.slevel;
    }

    fun void set_values_direct(float values[]){
        values @=> this.c;
    }

    fun void trigger(float vol){
        vol => this.vol;
        mout.gain(vol);
        spork ~ do_kick();
    }

    fun void do_kick(){

        // carrier
        SinOsc s => ADSR vEnv => mout;

        CurveTable pitchEnvelope => blackhole;
        c => pitchEnvelope.coefs; 
        Envelope kEnv => blackhole;
        kEnv.duration(300::ms);
        // pass time
        vEnv.set(a, d, slevel, r);
        vEnv.keyOn();
        kEnv.keyOn();
        now => time start;
        (this.a + this.d + this.s) => dur ads;

        // this while loop will cover the entire duration of the ADSR
        // vEnv in 1::samp intervals. This kind of loop is very tight and 
        // worth sending to a sampler to free up CPU cycles instead of 
        // regenerating the waveform repeatedly.
        int release_triggered;
        while(now < (start + ads + this.r)){

            pitchEnvelope.lookup(kEnv.value()) => s.freq;
            if (now > (start + ads) && !(release_triggered==1)){
                vEnv.keyOff();
                1 => release_triggered; 
            }
            1::samp => now;
        }

    }

    fun void patch(int n){
        if (n==1) set_values_direct(
            [0., 6590, -7.98,  
            0.017, 440, -.98,  
            0.05, 140, -.98,  
            .17, 114, 0, 
            .61, 54, 0, 
            1.8, 41.]);
        }

    // set defaults
    adssr(2::ms, 171::ms, 0::ms, 35::ms, 0.20);
    patch(1);

}

BKickONE kick;
kick.mout => dac;
kick.patch(2);
kick.trigger(.9);

2::second => now;

// edit -w

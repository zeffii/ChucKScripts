public class BKickONE {

    Mix2 mout;
    dur a, d, s, r;
    float slevel;
    float vol;

    float fg, fph, ffr;
    float sg, sph, sfr;

    fun void adssr(dur a, dur d, dur s, dur r, float slevel){
        a => this.a;
        d => this.d;
        s => this.s;
        r => this.r;
        slevel => this.slevel;
    }

    fun void set_values_direct(float values[]){
        values[0] => this.fg;
        values[1] => this.fph;
        values[2] => this.ffr;
        values[3] => this.sg;
        values[4] => this.sph;
        values[5] => this.sfr;
    }


    fun void trigger(float vol){
        vol => this.vol;
        mout.gain(vol);
        spork ~ do_kick();
    }

    fun void do_kick(){

        // carrier
        SinOsc s;
        s.gain(vol);
        s => ADSR vEnv => mout;

        // modulator
        SawOsc sawForm => s;
        s.phase(0);
        s.sync(2);
        sawForm.gain(fg);
        sawForm.phase(fph);
        sawForm.freq(ffr);

        // modulate the modulator
        SinOsc sShape => sawForm;
        sawForm.sync(2);
        sShape.gain(sg);
        sShape.phase(sph);
        sShape.freq(sfr);

        // pass time
        vEnv.set(a, d, slevel, r);
        vEnv.keyOn();
        (this.a + this.d + this.s) => now;

        vEnv.keyOff();
        this.r => now;

    }

    fun void patch(int n){
        if (n==1) set_values_direct([222.0, -pi, 1.27, -3.1, -pi/2, .01]);
        if (n==2) set_values_direct([616.0, -pi, 1.6, 0.987, -pi/2, 2.071]);
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

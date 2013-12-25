public class TapDelay extends Chubgraph {

    // used to connect externally
    // original source should remain connected to dac 
    // if you want to hear it.
    Mix2 mout;

    Delay a;
    Delay b; 

    dur max_a;
    dur len_a;
    dur max_b;
    dur len_b;

    // defaults
    0.9 => float damp_a;
    0.9 => float damp_b;

    // override delay config
    fun void set_delay(dur max_a, dur len_a, dur max_b, dur len_b){
        max_a => this.max_a;
        len_a => this.len_a;
        max_b => this.max_b;
        len_b => this.len_b;
        a.max(max_a);
        a.delay(len_a);
        b.max(max_b);
        b.delay(len_b);
    }

    fun void set_damp(float damp_a, float damp_b){
        damp_a => this.damp_a;
        damp_b => this.damp_b;
    }

    fun void set_delay_level(float amp){
        this.mout.gain(amp);
    }

    // do these things as soon as the class is instanciated
    set_delay(1::second, 0.3::second, 1::second, 0.5::second);
    a => Gain ga => a; ga.gain(damp_a);
    b => Gain gb => b; gb.gain(damp_b);
    inlet => a => mout.left;
    inlet => b => mout.right;

}

SinOsc s => ADSR k => Mix2 sound => dac;
sound.gain(0.5);

//TapDelay td;
//sound => td;
//td.mout => dac;
//td.set_delay_level(0.1);
k.set( 2::ms, 121::ms, 0.0, 0::ms );  //a, d, s, r

spork ~ do_kick(33);

5::second => now;


fun void do_kick(int tval){
    //tval => Std.mtof => s.freq;
    k.keyOn();
    s.phase(pi);
    SawOsc c => s;
    SinOsc t => c;
    s.sync(2);
    c.sync(2);
    t.freq(456.0);
    c.freq(0.3);
    c.phase(pi);
    c.gain(1065);

    1::second => now;
}

//WindChime.ck

public class WindChime {

    Mix2 mout;
    NRev rvb => mout;
    rvb.mix(0.22);
    mout.gain(0.3);
    dur a;
    dur d;
    dur s;
    float s_level;
    dur r;
    float midint;
    0.02 => float chime_vol; // default

    rvb => DelayA td => rvb;
    td.delay(70::ms);
    td.max(70::ms);
    td.gain(0.33);

    fun void set_chime_vol(float chime_vol){
        chime_vol => this.chime_vol;
    }

    fun void set_adsr(dur a, dur d, dur s, float s_level, dur r){
        a => this.a;
        d => this.d;
        s => this.s;
        s_level => this.s_level;
        r => this.r;
    }

    fun void s_play_note(){
        SinOsc s => ADSR env => rvb;
        SinOsc s2 => env;
        SinOsc s3 => env;
        SinOsc s0 => env;
        SinOsc m => s;

        env => Pan2 p;
        Math.random2f( 0.8, -0.8 ) => p.pan;
        NRev rvs[2];

        p.left => rvs[0] => mout.left;
        p.right => rvs[1] => mout.right;
        for(0 => int i; i<rvs.cap(); i++){
            rvs[i].mix(0.19);
        }

        s.sync(2);
        s.gain(chime_vol);
        midint => Std.mtof => float gfreq => s.freq;
        s2.freq((gfreq*2) + 0.012);
        s2.gain(chime_vol*0.8);
        s3.freq(gfreq*3);
        s3.gain(chime_vol*.22);
        s0.freq(gfreq*4/(midint/17.65));
        s0.gain(chime_vol*.052);
        m.freq(2 * gfreq);
        m.gain(3000);

        // Envelope config
        env.set( a, d, s_level, r );
        env.keyOn(); 
        (this.a + this.d + this.s) => now;
        env.keyOff(); 
        this.r => now;
    }

    fun void play_note(float midint){
        midint => this.midint;
        spork ~ s_play_note();
    }

    // this sets a default, incase i forget to
    set_adsr( 2::ms, 151::ms, 121::ms, .890, 35::ms );  //a, d, s, r

}

WindChime wc;
ADSR sound_sculpt[2];
wc.mout.left => sound_sculpt[0] => dac.left;
wc.mout.right => sound_sculpt[1] => dac.right;
sound_sculpt[0].set( 0::ms, 0::ms, 1.0, 3235::ms );  //a, d, s, r
sound_sculpt[1].set( 0::ms, 0::ms, 1.0, 3235::ms );  //a, d, s, r
wc.set_chime_vol(0.28);
sound_sculpt[0].keyOn();
sound_sculpt[1].keyOn();
120.0 => float start_note;
for(0 => int i; i<28; i++){
    wc.play_note(start_note-(i*0.6));
    Math.random2f(0.12, 0.112)::second =>now;
}
sound_sculpt[0].keyOff();
sound_sculpt[1].keyOff();
// prevent clicks
7::second => now;

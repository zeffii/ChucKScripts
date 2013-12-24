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
        SinOsc m => s;
        s.sync(2);
        s.gain(chime_vol);
        midint => Std.mtof => float gfreq => s.freq;
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

    // this sets a defult, incase i forget to
    set_adsr( 2::ms, 281::ms, 191::ms, .590, 35::ms );  //a, d, s, r

}

WindChime wc;
wc.mout => dac;
wc.set_chime_vol(0.08);

120.0 => float start_note;
for(0 => int i; i<25; i++){
    wc.play_note(start_note-(i*0.6));
    .11::second =>now;
}

// prevent clicks
2::second => now;

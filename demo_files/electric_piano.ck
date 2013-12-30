class TapDelay extends Chubgraph {

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
    0.7 => float damp_a;
    0.7 => float damp_b;

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

TapDelay td;
td.mout => dac;
td.set_delay_level(0.01);

Rhodey r[5];
LPF lpfs[5];
Mix2 pans[5];
Mix2 mout => dac;
mout => td => dac;
mout.gain(0.6);

mout.left => NRev _l => dac.left;
mout.right => NRev _r => dac.right;
_l.mix(0.73);
_r.mix(0.73);
_l.gain(0.12);
_r.gain(0.12);

connect(r);

[1,2,3,4] @=> int chd_triggers[];
repeat(4){
    for(0 => int i; i<chd_triggers.cap(); i++){
        chd_triggers[i] => int chord_num;
        set_notes(chords(chord_num));
        play_notes(r);
        3::second => now;
    }
}

fun int[] chords(int p){
    if (p==1) return [47, 57, 61, 64, 66];
    if (p==2) return [48, 59, 62, 64, 67]; 
    if (p==3) return [50, 57, 60, 64, 65];
    if (p==4) return [45, 55, 59, 60, 64];
}

fun void connect(Rhodey s[]){
    for(0 => int i; i<s.cap(); i++){
        s[i] => lpfs[i] => pans[i] => mout;
        ((((i%2)*2)-1)*0.8) => pans[i].pan;
    }
}

fun void set_notes(int notes[]){
    for(0 => int i; i<r.cap(); i++){
        notes[i] => Std.mtof => float fq => r[i].freq;
        //r[i].controlChange(11, fq);
        r[i].lfoSpeed(fq/notes[i]);
        r[i].lfoDepth(.38);
        lpfs[i].freq(fq);
        lpfs[i].Q(55);
    }
}
fun void play_notes(Rhodey s[]){
    for(0 => int i; i<s.cap(); i++){
        s[i].noteOn(.13);
    }
}
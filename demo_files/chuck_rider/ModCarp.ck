public class ModCarp {

    Mix2 out;
    Chorus manCh_left => out.left;
    Chorus manCh_right => out.right;

    manCh_left.modDepth(0.04);
    manCh_left.modFreq(.42);
    manCh_right.modDepth(0.08);
    manCh_right.modFreq(0.64);    

    SinOsc chorus_mod => blackhole;
    int note, attack, decay;
    float vol;

    fun void play(int note, float vol, int attack, int decay){
        note => this.note;
        vol => this.vol;
        decay => this.decay;
        attack => this.attack;
        spork ~ splay();
    }

    fun void splay(){
        // new object for each note? are we wasteful or what? :)
        StifKarp arper => LPF knight => 
                          ADSR madsr => manCh_left;
                               madsr => manCh_right;
                 arper => HPF steed => Chorus internal => madsr;

        note -12 => Std.mtof => float note_freq => arper.freq;

        // take out of -1 .. 1 range and into 0 --> 0.002
        (chorus_mod.last() + 1)/3600.0 => float chorus_adjuster;
        <<< chorus_adjuster >>>; 


        internal.modDepth(.001 + chorus_adjuster);
        internal.modFreq(note_freq/128);

        Step s => ADSR filterEnv => blackhole;
        arper.noteOn(vol);
        filterEnv.keyOn();
        filterEnv.set( attack::ms*0.3, (decay*2.8)::ms, 0.0, 0::ms );  //a, d, s, r
        madsr.keyOn();
        madsr.set( attack::ms*1.24, (decay*1.2)::ms, 0.00, 0::ms );  //a, d, s, r
                
        knight.Q(2.227);
        now => time start;
        steed.Q(1.1);
        steed.gain(1.2);
        while(now < start + (attack+decay)::ms){
            filterEnv.last() * 1129 + 349 => knight.freq;
            filterEnv.last() * 1229 + 419 => steed.freq;
            
            20::ms => now;
        }

    }


}
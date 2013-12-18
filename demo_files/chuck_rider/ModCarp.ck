public class ModCarp {

    Mix2 out;
    Chorus manCh_left => out.left;
    Chorus manCh_right => out.right;

    manCh_left.modDepth(0.04);
    manCh_left.modFreq(.42);
    manCh_right.modDepth(0.08);
    manCh_right.modFreq(0.64);    

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

        internal.modDepth(0.12);
        internal.modFreq(.14);

        Step s => ADSR filterEnv => blackhole;
        arper.noteOn(vol);
        filterEnv.keyOn();
        filterEnv.set( attack::ms*0.3, (decay*1.6)::ms, 0.0, 0::ms );  //a, d, s, r
        madsr.keyOn();
        madsr.set( attack::ms*1.24, (decay*1.12)::ms, 0.00, 0::ms );  //a, d, s, r
        note -12 => Std.mtof => float note_freq => arper.freq;
                
        knight.Q(2.127);
        now => time start;
        steed.freq(note_freq*2);
        steed.Q(12.9);
        steed.gain(0.4);
        while(now < start + (attack+decay)::ms){
            filterEnv.last() * 1129 + 399 => knight.freq;
            20::ms => now;
        }

    }


}
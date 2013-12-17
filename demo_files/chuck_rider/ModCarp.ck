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

        Step s => ADSR filterEnv => blackhole;
        arper.noteOn(vol);
        filterEnv.keyOn();
        filterEnv.set( attack::ms, (decay*1.2)::ms, 0.0, 0::ms );  //a, d, s, r
        madsr.keyOn();
        madsr.set( attack::ms, (decay*1.02)::ms, 0.00, 0::ms );  //a, d, s, r
        note -12 => Std.mtof => float note_freq => arper.freq;
                
        knight.Q(.827);
        now => time start;
        while(now < start + (attack+decay)::ms){
            filterEnv.last() * 2699 + 799 => knight.freq;
            20::ms => now;
        }

    }


}
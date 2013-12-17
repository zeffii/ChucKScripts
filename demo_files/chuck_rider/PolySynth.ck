public class PolySynth{

    // use this to hook up to externally.
    Mix2 out;

    float max_filter, max_q;
    float continual;
    int notes[];

    // some default values for these envelope params.
    2 => int volume_attack; 
    300 => int volume_decay;
    2 => int filter_attack;
    300 => int filter_decay;

    // for big changes
    fun void set_envelopes(int va, int vd, int fa, int fd){
        va => this.volume_attack;
        vd => this.volume_decay;
        fa => this.filter_attack;
        fd => this.filter_decay;
    }

    fun void play_synth(int notes[], float max_filter, float max_q, float continual){
        notes @=> this.notes;
        max_filter => this.max_filter;
        max_q => this.max_q;
        continual => this.continual;
        spork ~ splay_synth();
    }

    fun void splay_synth(){

        PolyWaveForm synth;
        synth.set_gain(0.21);

        LPF lpf1[2];
        synth.sum_waveforms.left => lpf1[0];
        synth.sum_waveforms.right => lpf1[1];

        ADSR vEnv[2];
        lpf1[0] => vEnv[0] => out.left;
        lpf1[1] => vEnv[1] => out.right;

        for(0 => int i; i<2; i++){
            // yeah, there's no consideration for sustain in this machine
            vEnv[i].set( volume_attack::ms, volume_decay::ms, 0.0, 0::ms );  //a, d, s, r
            vEnv[i].keyOn();
        }

        now => time start;
        volume_attack::ms + volume_decay::ms => dur attack_decay;
        (start + attack_decay) => time end;

        // frequency filter envelope
        Step s => ADSR fEnv => blackhole;
        fEnv.set( filter_attack::ms, filter_decay::ms, 0.0, 0::ms );
        fEnv.keyOn();
        synth.play_chord(notes, continual);

        // filter envelope, this loop passes time and adjusts the 
        // filter frequency every iteration using the value of fEnv.last()
        // at that time.
        float real_filter;
        while (now <= end){
            for(0 => int i; i<2; i++){
                fEnv.last() * max_filter => real_filter;
                real_filter => lpf1[i].freq;
                max_q => lpf1[i].Q;
            }
            2::ms => now;
        }
        
        fEnv.keyOff();
        for(0 => int i; i<2; i++){
            vEnv[i].keyOff();
        }


    }

}
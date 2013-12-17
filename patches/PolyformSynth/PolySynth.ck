public class PolySynth{

    int notes[];
    float max_filter, max_q;
    float continual;

    Mix2 out;

    fun void play_synth(int notes[], float max_filter, float max_q, float continual){

        notes @=> this.notes;
        max_filter => this.max_filter;
        max_q => this.max_q;
        continual => this.continual;
        spork ~ splay_synth();
    }

    fun void splay_synth(){

        // int notes[], float max_filter, float max_q, float continual

        PolyWaveForm synth;
        synth.set_gain(0.21);

        LPF lpf1[2];
        synth.sum_waveforms.left => lpf1[0];
        synth.sum_waveforms.right => lpf1[1];

        ADSR vEnv[2];
        lpf1[0] => vEnv[0] => out.left;
        lpf1[1] => vEnv[1] => out.right;

        for(0 => int i; i<2; i++){
            vEnv[i].set( 5::ms, 241::ms, 0.0, 0::ms );  //a, d, s, r
            vEnv[i].keyOn();
        }

        // take care of starting the thing
        400 => int decay;
        2 => int attack;
        now => time start;
        decay::ms + attack::ms => dur attack_decay;
        (start + attack_decay) => time end;

        // frequency filter envelope
        Step s => ADSR fEnv => blackhole;
        fEnv.set( 2::ms, 121::ms, 0.0, 0::ms );
        fEnv.keyOn();
        synth.play_chord(notes, continual);

        // takes care of filter envelope
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
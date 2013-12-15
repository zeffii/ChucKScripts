public class WaveformMixerMono{

    SinOsc vsin => Gain final;
    SawOsc vsaw => final;
    TriOsc vtri => final;
    PulseOsc vpls => final;  
    Noise vnse => final;

    440 => float frequency;

    fun void pwidth(float pw){
        pw => this.vpls.width;
    }

    fun void freq(float frequency){
        frequency => this.frequency;
        vsin.freq(frequency);
        vsaw.freq(frequency);
        vtri.freq(frequency);
        vpls.freq(frequency);
    }

    fun void mixer(float components[], float mgain){
        mixer(components);
        mgain => this.final.gain;
    }

    fun void mixer2(float continual){

        float mix_comp[];
        if (continual >= 7.9996) [0.0, 0.0, 0.0, 0.0, 1.0] @=> mix_comp;
        else if (continual <= 0.0001) [1.0, 0.0, 0.0, 0.0, 0.0] @=> mix_comp;
        else {
            continual => float j;
            Math.floor(j/2.0) $ int => int k;
            k*2 => int k2;
            ((j - k2) / 2.0) => float n;
            <<< k, n >>>;
            mix_arrays(k, n) @=> mix_comp;
        }
        mixer(mix_comp);
    }

    fun void mixer(float components[]){
        // set defautls, just in case -- make it a SinOsc
        if (!(components.cap() == 5)) {
            [1.0, 0.0, 0.0, 0.0, 0.0] @=> components;
        }

        float summer;
        for(0 => int i; i<components.cap(); i++){
            components[i] +=> summer;
        }

        if (summer <= 0.0) { 
            <<< "no sound!" >>>;
            0.0 => this.vsin.gain;
            0.0 => this.vsaw.gain;
            0.0 => this.vtri.gain;
            0.0 => this.vpls.gain;
            0.0 => this.vnse.gain;
        }
        else{
            components[0] / summer => this.vsin.gain;
            components[1] / summer => this.vsaw.gain;
            components[2] / summer => this.vtri.gain;
            components[3] / summer => this.vpls.gain;
            components[4] / summer => this.vnse.gain;
        }
    }

    fun float fixmin(float fin){
        if (fin < 0.0001) return 0.0;
        else return fin;
    }

    fun float[] mix_arrays(int idx, float amount){
        <<< idx, idx+1 >>>;
        [0.0, 0.0, 0.0, 0.0, 0.0] @=> float final_mix[];
        (1-amount) => fixmin => final_mix[idx];
        (amount) => fixmin => final_mix[idx+1];
        return final_mix;
    }

}

// Math.round

WaveformMixerMono bloop;
//bloop.final => dac;

// bloop.final.gain(0.1);
// bloop.mixer([0.0, 0.0, 0.0, 0.0, 1.0]);
// bloop.freq(500.0);

// 2::second => now;
// bloop.mixer([0.0, 0.0, 0.0, 0.0, 1.0], 0.0);
// 0.4::second => now;

// bloop.mixer([0.0, 0.0, 0.0, 0.0, 1.0], 0.2);
// bloop.freq(500.0);

// 2::second => now;

for(0.0 => float i; i<=8.0; 0.01+=> i){
    bloop.mixer2(i);
}


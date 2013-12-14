public class WaveformMixerMono{
 
    SinOsc vsin => Gain final;
    SawOsc vsaw => final;
    TriOsc vtri => final;
    PulseOsc vpls => final;  
    Noise vnse => final;
 
    440 => float frequency;
 
    fun void freq(float frequency){
        frequency => this.frequency;
        vsin.freq(frequency);
        vsaw.freq(frequency);
        vtri.freq(frequency);
        vpls.freq(frequency);
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
}
 
WaveformMixerMono bloop;
bloop.final => dac;
bloop.final.gain(0.4);
bloop.mixer([0.0, 0.0, 1.0, 0.0, 0.0]);
bloop.freq(500.0);
 
2::second => now;

public class PolyWaveForm{

    // this will act as the master out gain control
    .4 => float max_gain;
    Mix2 sum_waveforms;
    sum_waveforms.gain(max_gain);

    // defaults to a mono synth.
    1 => int polyphony;
    max_gain / polyphony => float voice_volume;

    WaveformMixerMono bloop[polyphony];
    Pan2 pan_array[polyphony];
    ADSR wfEnv[polyphony];

    fun void set_gain(float mgain){
        mgain => this.max_gain;
        sum_waveforms.gain(mgain);
    }

    // sets all the waveforms at once,
    // it might be nice to offer the option to set them indivually
    fun void waveform_mix(float continual){
        for(0 => int i; i<this.polyphony; i++){
            this.bloop[i].mixer2(continual);
        }
    }

    fun void play_chord(int notes[], int attack, int decay, float continual){

        // check if number of notes has change, an rewire if it has
        if (!(notes.cap() == polyphony)){
            set_polyphony(notes);
        }
        waveform_mix(continual);
        set_voice_volume(notes.cap());

        for(0 => int n; n<notes.cap(); n++){
            notes[n] => Std.mtof => this.bloop[n].freq;            
            this.wfEnv[n].keyOn();
            this.wfEnv[n].set( attack::ms, decay::ms, 0.00, 0::ms );
        }
    }

    fun void set_voice_volume(int polyphony){
        this.max_gain / this.polyphony => this.voice_volume;
    }

    fun void set_polyphony(int notes[]){

        if (notes.cap() <= 1) 1 => this.polyphony;
        else notes.cap() => this.polyphony;

        // this could be optimized by only adding elements if polyphony increases
        // and .clear() on the array and build a new one if polyphony decreases
        WaveformMixerMono bloop[this.polyphony] @=> this.bloop;
        Pan2 pan_array[this.polyphony] @=> this.pan_array;
        ADSR wfEnv[this.polyphony] @=> this.wfEnv;

        for(0 => int n; n<notes.cap(); n++){
            this.bloop[n].mixer2(2.3);
            this.bloop[n].final => this.wfEnv[n] => this.pan_array[n] => this.sum_waveforms;
            this.bloop[n].final.gain(this.voice_volume);
            ((((n%2)*2)-1)*0.9) => this.pan_array[n].pan;
        }
    }

}

// gist -m


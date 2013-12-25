public class WompSynth {

    Mix2 mout;
    dur a,d,s,r;
    float filter_1_freq;
    float filter_2_freq;
    float slev;

    fun void set_env(dur a, dur d, dur s, dur r, float slev){
        a => this.a;
        d => this.d;
        s => this.s;
        r => this.r;
        slev => this.slev;
    }

    fun void play_note(int midinote, float pwm_freq, int pwm_amp){
        spork ~ s_play_note(midinote, pwm_freq, pwm_amp);
    }

    fun void s_play_note(int midinote, float pwm_freq, int pwm_amp){
        SawOsc osc => ADSR envVol => mout;
        midinote => Std.mtof => osc.freq;
        SinOsc pwm => osc;
        osc.sync(2);

        pwm_freq => pwm.freq;
        pwm_amp => pwm.gain;

        envVol.set(a, d, slev, r);  
        envVol.keyOn();
        (this.a + this.d + this.s) => now;
        envVol.keyOff();
        this.r => now;
    }

    fun void chord(int notes[]){
        for(0 => int n; n<notes.cap(); n++){
            notes[n] => int note => Std.mtof => float pwm_note;
            play_note(note, pwm_note, 342);
        }
    }

    set_env(2::ms, 460::ms, 120::ms, 230::ms, 0.1);
}

WompSynth ws;
ws.mout => dac;
ws.mout.gain(0.12);

SinOsc panPos => blackhole;
Pan2 mpan;

ws.mout => DelayL td => mpan => dac;

td => Gain tn => td;
td.gain(0.94);
tn.gain(0.94);

.63::second => td.max; 
320::ms => dur d => td.delay;
panPos.freq(d/1::second);

spork ~ do_pan(d);
ws.chord([45,47,49,52]);

fun void do_pan(dur d){
    repeat(38){
        panPos.last() => mpan.pan;
        d => now;
    }
}


33::second => now;


public class BSnareOne {

    
    Mix2 pre_out => Mix2 mout;
    dur a, d, s, r;
    float slevel;
    float vol;
    float c[];
    1.0 => float speed;

    float v[];

    fun void adssr(dur a, dur d, dur s, dur r, float slevel){
        (a * speed) => this.a;
        (d * speed) => this.d;
        (s * speed) => this.s;
        (r * speed) => this.r;
        slevel => this.slevel;
    }

    fun void set_speed(float speed){
        speed => this.speed;
    }
    
    fun void set_values_direct(float values[]){
        values @=> this.c;
    }

    fun void trigger(float vol){
        vol => this.vol;
        mout.gain(vol);
        spork ~ do_kick();
    }

    fun void do_kick(){

        // carriers
        SinOsc vibrato => blackhole;
        vibrato.freq(466.1);
        
        Noise ns  => LPF lpf1 => ADSR vEnv => pre_out;
        Noise ns2 => HPF hpf2 => vEnv;
        Noise ns3 => HPF hpf3 => vEnv;
        Noise ns4 => HPF lpf4 => vEnv;
        SinOsc car => SinOsc modl => ADSR zEnv => pre_out;
        modl.sync(2);
        modl.gain(0.13);
        car.freq(24.42);
        car.phase(pi);
        car.gain(130);

        zEnv.set( 2::ms, 221::ms, 0.0, 25::ms );
        zEnv.keyOn();

        0.62 => float ns_maxgain;
        0.25 => float ns2_maxgain;;
        0.34 => float ns3_maxgain;;
        0.62 => float ns4_maxgain;;
        ns.gain(ns_maxgain);
        ns2.gain(ns2_maxgain);
        ns3.gain(ns3_maxgain);
        ns4.gain(ns4_maxgain);

        hpf2.freq(200);
        hpf2.Q(6.8);
        hpf3.freq(3200);
        hpf3.Q(1.8);
        lpf4.freq(110);
        lpf4.Q(51.1);
        
        CurveTable volumeEnvelope => blackhole;
        CurveTable pitchEnvelope => blackhole;
        v => volumeEnvelope.coefs;
        c => pitchEnvelope.coefs; 

        // pass time
        Envelope kEnv => blackhole;
        (a+d+s+r) => dur total_adsr;

        kEnv.duration(total_adsr);
        vEnv.set(a, d, slevel, r);
        vEnv.keyOn();
        kEnv.keyOn();
        now => time start;
        (this.a + this.d + this.s) => dur ads;

        // this while loop will cover the entire duration of the ADSR
        // vEnv in 1::samp intervals. This kind of loop is very tight and 
        // worth sending to a sampler to free up CPU cycles instead of 
        // regenerating the waveform repeatedly.
        int release_triggered;
        lpf1.Q(2);
        while(now < (start + ads + this.r)){

            (kEnv.value() => volumeEnvelope.lookup) => pre_out.gain;
            (kEnv.value() => pitchEnvelope.lookup)/.92 => lpf1.freq;
            //(vibrato.last() + 1)/2 * ns_maxgain => ns.gain;
            (vibrato.last() + 1)/2 * ns2_maxgain => ns2.gain;
            (vibrato.last() + 1)/2 * ns3_maxgain => ns3.gain;
            //(vibrato.last() + 1)/2 * ns4_maxgain => ns4.gain;
            if (now > (start + ads) && !(release_triggered==1)){
                vEnv.keyOff();
                1 => release_triggered; 
            }
            1::samp => now;
        }

    }

    fun void patch(int n){
        if (n==1) set_values_direct(
            [0., 12590, -1.98,  
            0.117, 9340, -.18,  
            0.25, 8620, -.18,  
            .57, 7804, 0, 
            .61, 7654, 0, 
            1.0, 3410.]);
        }

    fun void set_vol_env(float vol_coefs[]){
        vol_coefs @=> this.v;
    }

    // set defaults
    set_vol_env([0.0, 1.0, 0.2,  0.5, 0.8, 0.0,  1.0, 0.0]);
    adssr(2::ms, 131::ms, 30::ms, 115::ms, 0.15);
    patch(1);

}

// BSnareOne snare;
// snare.mout => ADSR snareShape => dac;
// snare.set_speed(1.83);
// snare.adssr(6::ms, 153::ms, 0::ms, 80::ms, 0.2);
// snare.patch(1);
// snareShape.set( 2::ms, 71::ms, 0.7, 145::ms );  //a, d, s, r
// snareShape.keyOn();
// snare.trigger(.8);

// 5::second => now;

// edit -w

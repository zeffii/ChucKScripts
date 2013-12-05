// samples.ck
NRev ae => dac;
ae.mix(0.0152);
ae.gain(0.0212);

load_sample(me.dir(-1), "clap_01") @=> SndBuf clapdata;
clap_trigger();
4::second => now;

fun void clap_trigger(){
    // seg 1
    spork ~ clap_part(0.024, 0.6, rpos());
    0.0118::second => now;
    // seg 2
    spork ~ clap_part(0.0023, 0.8, rpos());
    0.0243::second => now;
    // seg 3
    spork ~ clap_part(0.0033, 0.7, rpos());
    0.033::second=>now;
    // seg 4
    spork ~ clap_part(0.376, 1.0, rpos());
    0.7::second => now;  // tail
}

fun void clap_part(float fms, float force, int srpos){
    clapdata => ADSR t => HPF hpf => Gain dp => ae;
    t => HPF hpf2 => dp;
    dp.gain(22.0 * force);
    hpf.freq(1800);
    hpf2.freq(1300);
    hpf2.Q(2.3);

    t.set(0.2::ms, (fms)::second, 0.13, 220::ms );
    t.keyOn(1);
    srpos => clapdata.pos;
    (fms)::second => now;
    t.keyOff(1);
}

fun int rpos(){
    return Math.random2(700, 600);
}

fun SndBuf load_sample(string path, string wavname){
    // usage:  load_sample("kick_02") @=> SndBuf kick => dac;
 
    // turn incoming wavname into   path/wavename.wav
    SndBuf temp_buff;
    path + "/audio/" + wavname  + ".wav" => temp_buff.read;
 
    // set to end, and set gain, then return the object
    temp_buff.samples() => temp_buff.pos;   
    0.8 => temp_buff.gain; // optional default

    // return a reference to the new buffer object.
    return temp_buff;
}

fun SndBuf load_sample(string wavname){
 
    // usage
    // load_sample("kick_02") @=> SndBuf kick => dac;
 
    // turn incoming wavname into   path/wavename.wav
    // return a reference to a new buffer object.
    SndBuf temp_buff;
    me.dir() + "/audio/" + wavname  + ".wav" => temp_buff.read;
 
    // set to end, and set gain, then return the object
    temp_buff.samples() => temp_buff.pos;   
    0.8 => temp_buff.gain;
    return temp_buff;
}

load_sample("hihat_04") @=> SndBuf perc_sample;
perc_sample => Gain master_sample => dac;
master_sample => Pan2 sample_pan => dac;

LiSa liveSampl1 => NRev rname => Gain big => dac;
(10*240*22)::samp => dur bigtime => liveSampl1.duration; 

rname.mix(0.2);
master_sample => liveSampl1;
big.gain(4);

1 => liveSampl1.record;
for(2 => int j; j<10; j++){
    ((((j%2)*2)-1)*.9) => sample_pan.pan;
    for(0 => int i; i<240; i++){
        0.01 => master_sample.gain;
        0 + (i*j*142)=> perc_sample.pos;
        22::samp => now;
    }
}
0 => liveSampl1.record;

for(0 => int i; i<4; i++){
    0 => liveSampl1.playPos;
    -.3 => liveSampl1.rate;
    1 => liveSampl1.play;
    bigtime => now;
    0 => liveSampl1.play;
}

PolySynth polysynBass;
PolySynth polysynArp;
PolySynth polysynLead;
ModCarp carper;

NRev reverb_bass[2];
reverb_bass[0].mix(0.013);
reverb_bass[1].mix(0.013);
polysynBass.out.gain(1.5);
polysynBass.out.left => DelayA bassD =>  reverb_bass[0] => dac.left;
polysynBass.out.right => reverb_bass[1] => dac.right;
123::samp => bassD.delay => bassD.max;

NRev reverb_arp[2];
reverb_arp[0].mix(0.07);
reverb_arp[1].mix(0.07);
polysynArp.out.gain(.31);
polysynArp.out.left => reverb_arp[0] => dac.left;
polysynArp.out.right => DelayA arpD => reverb_arp[1]  => dac.right;
223::samp => arpD.delay => arpD.max;

NRev reverb_lead[2];
reverb_lead[0].mix(0.03);
reverb_lead[1].mix(0.03);
polysynLead.out.gain(.71);
polysynLead.out.left => reverb_lead[0] => dac.left;
polysynLead.out.right => DelayA leadD => reverb_lead[1]  => dac.right;
63::samp => leadD.delay => leadD.max;


carper.out => dac;


//synth.max_gain(0.2);

[1, 1, 0, 0,  1, 1, 0, 0,  1, 1, 0, 0,  0, 0, 0, 0,    1, 1, 0, 0,  0, 0, 0, 0,  1, 1, 0, 0,  0, 0, 0, 0] @=> int pseq[];

[0, 52, 54, 55] @=> int arp_1_notes[];
[0, 50, 52, 53] @=> int arp_2_notes[];

// 1 = e2, 2=f#2  3=g2
// F#2|0|G-2|F#2|F#2|G-2|F#2|F#2|G-2|F#2|F#2|F#2|E-2|F#2|F#2|G-2|F#2|0|G-2|F#2|F#2|G-2|F#2|F#2|G#2|F#2|F#2|F#2|E-2|F#2|F#2
[2,0,3,2,2,3,2,2,3,2,2,2,1,2,2,3,2,0,3,2,2,3,2,2,3,2,2,2,1,2,2] @=> int arp_1_triggers[];

[42, 40, 43] @=> int bass_notes[];


// INTRO
repeat(0){

    polysynArp.set_envelopes(2, 177, 2, 1410);

    spork ~ play_arp(arp_1_notes, arp_1_triggers);
    spork ~ play_bassline(bass_notes[0], pseq, 0, 32);
    advance_time(32);

    spork ~ play_arp(arp_2_notes, arp_1_triggers);
    spork ~ play_bassline(bass_notes[1], pseq, 0, 32);
    advance_time(32);

    spork ~ play_arp(arp_1_notes, arp_1_triggers);
    spork ~ play_bassline(bass_notes[0], pseq, 0, 32);
    advance_time(32);

    spork ~ play_arp(arp_1_notes, arp_1_triggers);
    spork ~ play_bassline(bass_notes[2], pseq, 0, 32);
    advance_time(32);

}


// MID , lead
60 => int tnote;
polysynLead.set_envelopes(32, 1177, 42, 1310);
polysynLead.play_synth([tnote, tnote], 4500.0, 2.9, 3.2);
advance_time(32);




fun void play_bassline(int note, int triggers[], int start, int end){
    // extra insurance
    if (end > triggers.cap()) triggers.cap() => end;
    
    for(start => int i; i<end; i++){
        if ( triggers[i] == 1){
            polysynBass.play_synth([note, note], 1500.0, 2.9, 3.2);
        }
        advance_time();
    }
}

fun void play_arp(int notes[], int triggers[]){

    for(0 => int i; i<triggers.cap(); i++){
        triggers[i] => int trigval;
        if (trigval > 0) {
            notes[trigval] + 12 => int note_val;
            (notes[trigval] * 90) => float filter_from_freq;
            polysynArp.play_synth([note_val,note_val], filter_from_freq+1100.0, 5.2, 2.4);
            carper.play(note_val, 0.5, 2, 140);
        }
        advance_time();
    }
}


// overloading, careful.
fun void advance_time(int num_units){
    (0.13::second * num_units) => now;
}
fun void advance_time(){
    0.13::second => now;
}


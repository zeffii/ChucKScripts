PolySynth polysynBass;
PolySynth polysynArp;
PolySynth polysynLead;
ModCarp carper;

carper.out => dac;

NRev reverb_bass[2];
reverb_bass[0].mix(0.009);
reverb_bass[1].mix(0.009);
polysynBass.out.gain(3.2);
polysynBass.out.left => DelayA bassD =>  reverb_bass[0] => dac.left;
polysynBass.out.right => reverb_bass[1] => dac.right;
123::samp => bassD.delay => bassD.max;

NRev reverb_arp[2];
reverb_arp[0].mix(0.04);
reverb_arp[1].mix(0.04);
polysynArp.out.gain(.41);
polysynArp.out.left => reverb_arp[0] => dac.left;
polysynArp.out.right => DelayA arpD => reverb_arp[1]  => dac.right;
43::samp => arpD.delay => arpD.max;

NRev reverb_lead[2];
reverb_lead[0].mix(0.11);
reverb_lead[1].mix(0.11);
polysynLead.out.gain(.21);
reverb_lead[0].gain(0.16);
reverb_lead[1].gain(0.16);
polysynLead.out => Mix2 leadgain => dac;
leadgain.gain(1.81);
Chorus pads[2];
polysynLead.out.left => pads[0] => reverb_lead[0] => dac.left;
polysynLead.out.right => pads[1] => DelayA leadD => reverb_lead[1]  => dac.right;


143::samp => leadD.delay => leadD.max;

for(0 => int i; i<pads.cap(); i++){
    pads[i].gain(21.2);
    pads[i].modFreq(0.25 + i*0.032);
    pads[i].modDepth(.052 + i*0.014);
}



[1, 1, 0, 0,  1, 1, 0, 0,  1, 1, 0, 0,  0, 0, 0, 0,
 1, 1, 0, 0,  0, 0, 0, 0,  1, 1, 0, 0,  0, 0, 0, 0] @=> int pseq[];

[0, 52, 54, 55] @=> int arp_1_notes[];
[0, 50, 52, 53] @=> int arp_2_notes[];

[2,0,3,2,2,3,2,2,3,2,2,2,1,2,2,3,2,0,3,2,2,3,2,2,3,2,2,2,1,2,2] @=> int arp_1_triggers[];

[42, 40, 43] @=> int bass_notes[];

// this is mighty ugly, but it allows each note to have a unique decay length.
[[54, 500], [0, 0], [55, 300], [54, 300], [61, 2300], 
[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], 
[66, 600], [0, 0], [64, 500], [66, 200], [61, 3100], 
[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], 
[54, 350], [0, 0], [55, 300], [54, 360], [61, 370], [0, 0], [66, 300], [0, 0], [64, 5300]
] @=> int lead_notes_1[][];


[[54, 500], [0, 0], [55, 300], [54, 300], [61, 2300], 
[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], 
[66, 600], [0, 0], [64, 500], [66, 200], [61, 3100], 
[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], 
[54, 350], [0, 0], [55, 300], [54, 360], [61, 370], [0, 0], [66, 300], [0, 0], [67, 5300]
] @=> int lead_notes_2[][];


// INTRO
repeat(1){

    polysynArp.set_envelopes(2, 217, 2, 1410);

        spork ~ play_lead(lead_notes_1);
    spork ~ play_arp(arp_1_notes, arp_1_triggers);
    spork ~ play_bassline(bass_notes[0], pseq, 0, 32);
    advance_time(32);

    spork ~ play_arp(arp_2_notes, arp_1_triggers);
    spork ~ play_bassline(bass_notes[1], pseq, 0, 32);
    advance_time(32);

        spork ~ play_lead(lead_notes_2);
    spork ~ play_arp(arp_1_notes, arp_1_triggers);
    spork ~ play_bassline(bass_notes[0], pseq, 0, 32);
    advance_time(32);

    spork ~ play_arp(arp_1_notes, arp_1_triggers);
    spork ~ play_bassline(bass_notes[2], pseq, 0, 32);
    advance_time(32);

}

fun int to_int(float input){
    input $ int => int output;
    return output;
}


// lead
fun void play_lead(int sequence[][]){

    int tnote;
    for(0 => int i; i<sequence.cap(); i++){
        sequence[i][0] => int tval;
        if (tval > 0) {
            tval + 12 => tnote;
            sequence[i][1] => int decay;
            polysynLead.set_envelopes(42, decay, 22, to_int(decay*1.3));
            polysynLead.play_synth([tnote, tnote], 7500.0, 2.9, 2.1);
        }

        advance_time();
    }
    advance_time(25);
}

fun void play_bassline(int note, int triggers[], int start, int end){
    // extra insurance
    if (end > triggers.cap()) triggers.cap() => end;
    
    for(start => int i; i<end; i++){
        if ( triggers[i] == 1){
            polysynBass.play_synth([note, note], 1500.0, 2.9, 1.2);
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

// gist -m 
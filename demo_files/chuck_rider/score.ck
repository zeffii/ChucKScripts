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
reverb_lead[0].mix(0.59);
reverb_lead[1].mix(0.59);
polysynLead.out.gain(.41);
reverb_lead[0].gain(0.09);
reverb_lead[1].gain(0.09);
polysynLead.out => Mix2 leadgain => dac;
leadgain.gain(1.1);
Chorus pads[2];
polysynLead.out.left => pads[0] => reverb_lead[0] => dac.left;
polysynLead.out.right => pads[1] => DelayA leadD => reverb_lead[1]  => dac.right;
143::samp => leadD.delay => leadD.max;

for(0 => int i; i<pads.cap(); i++){
    pads[i].modFreq(0.1 + i*0.002);
    pads[i].modDepth(0.23);
}


carper.out => dac;


//synth.max_gain(0.2);

[1, 1, 0, 0,  1, 1, 0, 0,  1, 1, 0, 0,  0, 0, 0, 0,    1, 1, 0, 0,  0, 0, 0, 0,  1, 1, 0, 0,  0, 0, 0, 0] @=> int pseq[];

[0, 52, 54, 55] @=> int arp_1_notes[];
[0, 50, 52, 53] @=> int arp_2_notes[];

// 1 = e2, 2=f#2  3=g2
// F#2|0|G-2|F#2|F#2|G-2|F#2|F#2|G-2|F#2|F#2|F#2|E-2|F#2|F#2|G-2|F#2|0|G-2|F#2|F#2|G-2|F#2|F#2|G#2|F#2|F#2|F#2|E-2|F#2|F#2
[2,0,3,2,2,3,2,2,3,2,2,2,1,2,2,3,2,0,3,2,2,3,2,2,3,2,2,2,1,2,2] @=> int arp_1_triggers[];

[42, 40, 43] @=> int bass_notes[];

[54, 0,55,54,61,   
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 66, 0,64,66,61, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 0,
 54, 0,55,54,61, 0,66, 0,64] @=> int lead_notes_1[];


[54, 0,55,54,61,   
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 66, 0,64,66,61, 0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 0,
 54, 0,55,54,61, 0,66, 0,67] @=> int lead_notes_2[];


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


// lead
fun void play_lead(int sequence[]){
    polysynLead.set_envelopes(42, 1227, 22, 1610);

    int tnote;
    for(0 => int i; i<sequence.cap(); i++){
        sequence[i] => int tval;
        if (tval > 0) {
            tval + 12 => tnote;
            polysynLead.play_synth([tnote, tnote], 7500.0, 2.9, 2.1);
        }

        advance_time();
    }
    advance_time(10);
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


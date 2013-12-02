"sqr" => string voiceType;

Osc voiceOsc[1];

if (voiceType == "saw") {new SawOsc @=> voiceOsc[0];}
else if (voiceType == "sin") {new SinOsc @=> voiceOsc[0];}
else if (voiceType == "sqr") {new SqrOsc @=> voiceOsc[0];}

voiceOsc[0].gain(0.5);
voiceOsc[0] => dac; 

2::second => now;

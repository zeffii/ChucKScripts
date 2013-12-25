SinOsc s;

s => ADSR vEnv =>  dac;
s.gain(0.5);

vEnv.set( 0::ms, 321::ms, 0.00, 0::ms );  //a, d, s, r
vEnv.keyOn();

SawOsc sawForm => s;
s.phase(0);
s.sync(2);
sawForm.gain(452);
sawForm.phase(-pi);
sawForm.freq(.67);

SinOsc sShape => sawForm;
sawForm.sync(2);
sShape.phase(0);
sShape.freq(34.12);
sShape.gain(225);


2::second => now;
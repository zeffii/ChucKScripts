SinOsc s;

s => ADSR vEnv =>  dac;
s.gain(0.5);

vEnv.set( 0::ms, 321::ms, 0.00, 0::ms );  //a, d, s, r
vEnv.keyOn();

SawOsc sawForm => s;
s.phase(0);
s.sync(2);
sawForm.gain(222);
sawForm.phase(-pi);
sawForm.freq(1.27);

SinOsc sShape => sawForm;
sawForm.sync(2);
sShape.phase(-pi/2);
sShape.freq(.01);
sShape.gain(-3.1);


2::second => now;
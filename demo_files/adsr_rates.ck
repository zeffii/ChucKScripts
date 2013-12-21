SinOsc s => Envelope sEnv => dac; 
s.gain(0.2);

sEnv.rate(1.0);
sEnv.value(.0);      // defaults
sEnv.target(1.0);    // defaults
sEnv.duration(500::ms);
sEnv.keyOn();

1::second => now;

sEnv.target(0.0);
sEnv.keyOn();

1::second => now;

sEnv.value(0.0);
sEnv.rate(0.2);
sEnv.target(1.0);
sEnv.keyOn();

1::second => now;

sEnv.target(0.0);
sEnv.keyOn();

1::second => now;


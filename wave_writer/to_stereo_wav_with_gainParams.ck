//me.arg(0) => string filename;
//if( filename.length() == 0 ) "foo.wav" => filename;

dac => Mix2 regulator => WvOut2 w => blackhole;
//"data/session" => w.autoPrefix;

regulator.gain(1.0);
"woooot.wav" => w.wavFilename;
1 => w.record;
3::second => now;

// everything in between gets recorded.


0 => w.record;

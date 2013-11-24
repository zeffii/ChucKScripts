//me.arg(0) => string filename;
//if( filename.length() == 0 ) "foo.wav" => filename;

dac => WvOut2 w => blackhole;
//"data/session" => w.autoPrefix;
"woooot.wav" => w.wavFilename;
1 => w.record;
3::second => now;

// everything in between


0 => w.record;

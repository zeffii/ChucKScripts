#### string
.tolower()  
.toupper()  
.trim()  
.ltrim()  
.rtrim()  

#### Std
.atoi(string val) // alpha to int  
.atof(string val) // alpha to float  
.itoa(int val) // int to alpha  
.ftoa(int val) // float to alpha  
.mtof()
.ftom()
.abs()
.fabs()
.sgn
.powtodb(float val) // signal power ratio to dB  
.dbtopow(float val) // dB to signal power ratio  
.rmstob(float val) // linear amp to dB  
.dbtorms(float val) // dB to linear amp  

#### Math

seed, forces reproducible random  
.srandom(n) //  use n to set random seed
.random() // random int between 0, max int
.randomf() // random float between 0.0 and 1.0
.random2(a, b) // random int between a and b
.random2f(a, b) // random float between a and b

*Math geometry and operations on numbers*

.hypot(fx, fy)  // takes floats, returns euclidean distance of vector 
.pow(a, b)  // a^b, takes ints or floats.
.sqrt(x)
.exp(x)
.log(x) // natural log
.log2(x)  // log base 2
.log10(x) // base 10

*Math utility functions*

.floor(float) // round down to next integeral ( 2.3 becomes 2.0 )
.ceil(float) // round up to next integral  ( 2.3 becomes  3.0 )
.round(float) // regular rounding rules apply
.trunc() // round to largest integral val no greater than x
.fmod(float, float)  // float remainder of x / y
.min(float, float) // returns lowest value of the two inputs
.max(float, float) // returns highest value of the two inputs
.nextpow2(float) // (int) returns smallest int (power of 2 greater than input)

// all of these return floats
Math.sin(x) // for parameter control, not for generating audio 
Math.cos(x)
Math.tan(x)
Math.asin(x)
Math.acos(x)
Math.atan2(x,y)
Math.sinh(x)
Math.cosh(x)
Math.tanh(x)

// week 2 section 4
dac.left 
dac.right
dac.chan(0)
dac.chan(1)
dac.chan(n) // in case more than 2 channels available

// Panning! 
SinOsc s => Pan2 p => dac;
1.0 => p.pan; // one side
-1.0 => p.pan; // other side

pi  // 3.141592...

// noise generator, doesn't produce a repeating waveform, use
// as SinOsc etc
Noise n;

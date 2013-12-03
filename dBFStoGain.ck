/* Allows inputting a dBFS value like a normal (sound engineer)
person (e.g. -6dB for a "tame" peak value), and getting a
ChucK "gain" number out (e.g. for -6dB, 0.501187).
The results seem to indicate that ChucK's gain, calculated
using the 'Std.dbtorms()' method, conforms to amplitude
(as a ratio) as shown in the chart at the top of
http://en.wikipedia.org/wiki/Decibel.

I'd call it verified:
dBFStoGain( x ) = y
 +3 = ~1.4
  0 = 1      // Unity gain
 -6 = ~0.5
-12 = ~0.25
*/

// Not exactly rocket science >_<
fun float dBFStoGain(float dBFS){  
    return Std.dbtorms( dBFS + 100 );
}

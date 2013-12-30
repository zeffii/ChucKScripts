## audio output  


### [ugen]: dac  

digital / analog converter  
abstraction for underlying audio output device  
  
(control parameters)  

    .left - input to left channel  
    .right - input to right channel  
    .chan( int n ) - returns nth channel (all UGens have this function)  
  
  
### [ugen]: adc  
  
analog / digital converter
abstraction for underlying audio input device  
  
(control parameters)  
  
    .left - output of left channel  
    .right - output of right channel  
    .chan( int n ) - returns nth channel (all UGens have this   function)


### [ugen]: blackhole    
  
sample rate sample sucker, like dac, ticks ugens, but no more  
see examples: fm.ck  
  

### [ugen]: Gain  
  
gain control unit  

> all unit generators can change their gain. this is a way to add N outputs together and scale them.  
  
see examples: i-robot.ck  

(control parameters)  
  
    .gain - ( float , READ/WRITE ) - set gain ( all ugen's have this )
  
example    
  
     Noise n => Gain g => dac;
     SinOsc s => g;
     .3 => g.gain;
     while( true ) { 100::ms => now; }
  
  

## wave forms  
  
  
### [ugen]: Noise  
  
white noise generator  
see examples: wind.ck powerup.ck  
  
  
### [ugen]: Impulse  
  
pulse generator - can set the value of the current sample  
default for each sample is 0 if not set  

(control parameters)  

    .next - ( float , READ/WRITE ) - set value of next sample to be generated. 

> if you are using the UGen.last method to read the output of the impulse, the value set by Impulse.next does not appear as the output until after the next sample boundary. In this case, there is a consistent 1::samp offset between setting .next and reading that value using .last  
  
example  
  
     Impulse i => dac;  
     while( true ) {  
        1.0 => i.next;  
        100::ms => now;  
     }  


### [ugen]: Step  
  
step generator - like Impulse, but once a value is set, it is held for all following samples, until value is set again  

see examples: step.ck  

(control parameters)  

    .next - ( float , READ/WRITE ) - set the step value    
  
example  

     Step s => dac;  
     -1.0 => float amp;  
     // square wave using Step  
     while( true ) {  
         -amp => amp => s.next;  
         800::samp => now;  
     }  
  

  
## basic signal processing  
  
  
### [ugen]: HalfRect  
  
half wave rectifier  
for half-wave rectification.  
  
  
### [ugen]: FullRect  

full wave rectifier  

  
### [ugen]: ZeroX  
  
zero crossing detector  
emits a single pulse at the the zero crossing in the direction of the zero crossing.  
  
see examples: zerox.ck  
  
  

## filters  
 

### [ugen]: BiQuad  
  
> STK biquad (two-pole, two-zero) filter class.  This protected Filter subclass implements a two-pole, two-zero digital filter.  A method
is provided for creating a resonance in the frequency response while maintaining a constant filter gain.    
by Perry R. Cook and Gary P. Scavone, 1995 - 2002.  

(control parameters)  

    .b2 - ( float , READ/WRITE ) - b2 coefficient
    .b1 - ( float , READ/WRITE ) - b1 coefficient
    .b0 - ( float , READ/WRITE ) - b0 coefficient
    .a2 - ( float , READ/WRITE ) - a2 coefficient
    .a1 - ( float , READ/WRITE ) - a1 coefficient
    .a0 - ( float , READ only ) - a0 coefficient
    .pfreq - ( float , READ/WRITE) - set resonance frequency (poles)
    .prad - ( float , READ/WRITE ) - pole radius (less than 1 to be stable)
    .zfreq - ( float , READ/WRITE ) - notch frequency
    .zrad - ( float , READ/WRITE ) - zero radius
    .norm - ( float , READ/WRITE ) - normalization
    .eqzs - ( float , READ/WRITE ) - equal gain zeroes
  
  
### [ugen]: Filter  

> STK filter class. This class implements a generic structure which can be used to create a wide range of filters. It can function independently or be subclassed to provide more specific controls based on a particular filter type.   
In particular, this class implements the standard difference equation:  

    a[0]*y[n] = b[0]*x[n] + ... + b[nb]*x[n-nb] -
                a[1]*y[n-1] - ... - a[na]*y[n-na]  

    If a[0] is not equal to 1, the filter coeffcients
    are normalized by a[0].

> The \e gain parameter is applied at the filter input and does not affect the coefficient values. The default gain value is 1.0.  This structure results in one extra multiply per computed sample, but allows easy control of the overall filter gain.  
by Perry R. Cook and Gary P. Scavone, 1995 - 2002.  

(control parameters)  

    .coefs - ( string , WRITE only )  
  
  
### [ugen]: OnePole  
  
  
> STK one-pole filter class. This protected Filter subclass implements a one-pole digital filter. A method is provided for setting the pole position along 
the real axis of the z-plane while maintaining a constant peak filter gain.  
by Perry R. Cook and Gary P. Scavone, 1995 - 2002.  

(control parameters)  

    .a1 - ( float , READ/WRITE ) - filter coefficient
    .b0 - ( float , READ/WRITE ) - filter coefficient
    .pole - ( float , READ/WRITE ) - set pole position along real axis of z-plane  
  

### [ugen]: TwoPole  
  

> STK two-pole filter class. see examples: powerup.ck This protected Filter subclass implements a two-pole digital filter. A method is provided for creating a resonance in the frequency response while maintaining a nearly
constant filter gain.  
by Perry R. Cook and Gary P. Scavone, 1995 - 2002.  

(control parameters)  

    .a1 - ( float , READ/WRITE ) - filter coefficient
    .a2 - ( float , READ/WRITE ) - filter coefficient
    .b0 - ( float , READ/WRITE ) - filter coefficient
    .freq - ( float , READ/WRITE ) - filter resonance frequency
    .radius - ( float , READ/WRITE ) - filter resonance radius
    .norm - ( int , READ/WRITE ) - toggle filter normalization
  
  
### [ugen]: OneZero  
  

> STK one-zero filter class. This protected Filter subclass implements
a one-zero digital filter.  A method is provided for setting the zero position
along the real axis of the z-plane while maintaining a constant filter gain.  
by Perry R. Cook and Gary P. Scavone, 1995 - 2002.  

(control parameters)  

    .zero - ( float , READ/WRITE ) - set zero position
    .b0 - ( float , READ/WRITE ) - filter coefficient
    .b1 - ( float , READ/WRITE ) - filter coefficient

### [ugen]: TwoZero  
  

> STK two-zero filter class. This protected Filter subclass implements a two-zero digital filter.  A method is provided for creating a "notch" in the 
frequency response while maintaining a constant filter gain.  
by Perry R. Cook and Gary P. Scavone, 1995 - 2002.  

(control parameters)  

    .b0 - ( float , READ/WRITE ) - filter coefficient
    .b1 - ( float , READ/WRITE ) - filter coefficient
    .b2 - ( float , READ/WRITE ) - filter coefficient
    .freq - ( float , READ/WRITE ) - filter notch frequency
    .radius - ( float , READ/WRITE ) - filter notch radius
  
  
### [ugen]: PoleZero  
  

> STK one-pole, one-zero filter class. This protected Filter subclass implements a one-pole, one-zero digital filter.  A method is provided for creating an allpass filter with a given coefficient. Another method is provided to create a DC blocking filter.  
by Perry R. Cook and Gary P. Scavone, 1995 - 2002.  
  
(control parameters)  

    .a1 - ( float , READ/WRITE ) - filter coefficient
    .b0 - ( float , READ/WRITE ) - filter coefficient
    .b1 - ( float , READ/WRITE ) - filter coefficient
    .blockZero - ( float , READ/WRITE ) - DC blocking filter with given pole position
    .allpass - ( float , READ/WRITE ) - allpass filter with given coefficient
  
  
### [ugen]: LPF   
  
  
resonant low pass filter. (extends FilterBasic)

> Resonant low pass filter.  2nd order Butterworth. (In the future, this class may be expanded so that order and type of filter can be set).  
  
(control parameters)  

    .freq - ( float , READ/WRITE ) - cutoff frequency
    .Q - ( float , READ/WRITE ) - resonance (default is 1)
    .set - ( float, float, WRITE only ) - set freq and Q at once
  
  
### [ugen]: HPF  

resonant high pass filter. (extends FilterBasic)  

> Resonant high pass filter. 2nd order Butterworth. (In the future, this class may be expanded so that order and type of filter can be set).  

(control parameters)  

    .freq - ( float , READ/WRITE ) - cutoff frequency
    .Q - ( float , READ/WRITE ) - resonance (default is 1)
    .set - ( float, float, WRITE only ) - set freq and Q at once
  

### [ugen]: BPF  

band pass filter. (extends FilterBasic)  

> Band pass filter. 2nd order Butterworth. (In the future, this class may be expanded so that order and type of filter can be set). 

(control parameters)  

    .freq - ( float , READ/WRITE ) - center frequency
    .Q - ( float , READ/WRITE ) - Q (quality)
    .set - ( float, float, WRITE only ) - set freq and Q at once
  
  
### [ugen]: BRF  

band reject filter. (extends FilterBasic)  

> Band reject filter. 2nd order Butterworth. (In the future, this class may be expanded so that order and type of filter can be set).
  
(control parameters)  

    .freq - ( float , READ/WRITE ) - center frequency
    .Q - ( float , READ/WRITE ) - Q (quality)
    .set - ( float, float, WRITE only ) - set freq and Q at once
  
  
### [ugen]: ResonZ  

resonance filter. (extends FilterBasic)  

> Resonance filter.  BiQuad with equal-gain zeros. keeps gain under control independent of frequency.  
  
(control parameters)  
  
    .freq - ( float , READ/WRITE ) - center frequency
    .Q - ( float , READ/WRITE ) - Q (quality)
    .set - ( float, float, WRITE only ) - set freq and Q at once
  
  
### [ugen]: FilterBasic  

filter basic base class. (extends FilterBasic)  
  
(control parameters)  
  
    .freq - ( float , READ/WRITE ) - frequency
    .Q - ( float , READ/WRITE ) - Q
    .set - ( float, float, WRITE only ) - set freq and Q at once
  
  
### [ugen]: Dyno  
  
dynamics processor
includes limiter, compressor, expander, noise gate, and ducker (presets)
see examples:  
  
default limiter values:  
  
    slopeAbove = 0.1
    slopeBelow = 1.0
    thresh = 0.5
    attackTime = 5 ms
    releaseTime = 300 ms
    externalSideInput = 0 (false)
  
default compressor values:  
  
    slopeAbove = 0.5
    slopeBelow = 1.0
    thresh = 0.5
    attackTime = 5 ms
    releaseTime = 300 ms
    externalSideInput = 0 (false)
  
default expander values:  
  
    slopeAbove = 2.0
    slopeBelow = 1.0
    thresh = 0.5
    attackTime = 20 ms
    releaseTime = 400 ms
    externalSideInput = 0 (false)
  
default noise gate values:  

    slopeAbove = 1.0
    slopeBelow = 10000000
    thresh = 0.1
    attackTime = 11 ms
    releaseTime = 100 ms
    externalSideInput = 0 (false)
  
default ducker values:  

    slopeAbove = 0.5
    slopeBelow = 1.0
    thresh = 0.1
    attackTime = 100 ms
    releaseTime = 1000 ms
    externalSideInput = 1 (true)
    Note that the input to sideInput determines the level of 
    gain, not the direct signal input to Dyno.  
  
(control parameters, quick defaults for the above values)  

    .limit - () - set parameters to default limiter values
    .compress - () - set parameters to default compressor values
    .expand - () - set parameters to default expander values
    .gate - () - set parameters to default noise gate values
    .duck - () - set parameters to default ducker values
  
(control parameters)  
  
    .thresh - ( float, READ/WRITE ) 
        the point above which to stop using slopeBelow and start using slopeAbove to determine output gain vs input gain  
  
    .attackTime - ( dur, READ/WRITE ) 
        duration for the envelope to move linearly from current value to the absolute value of the signal's amplitude  
  
    .releaseTime - ( dur, READ/WRITE )
        duration for the envelope to decay down to around 1/10 of its current amplitude, if not brought back up by the signal
  
    .ratio - ( float, READ/WRITE )
        alternate way of setting slopeAbove and slopeBelow; sets slopeBelow to 1.0 and slopeAbove to 1.0 / ratio  
  
    .slopeBelow - ( float, READ/WRITE )
        determines the slope of the output gain vs the input envelope's level in dB when the envelope is below  thresh. For example, if slopeBelow were 0.5, thresh were 0.1, and the envelope's value were 0.05, the envelope's amplitude would be about 6 dB below thresh, so a gain of 3 dB would be applied to bring the output signal's amplitude up to only 3 dB below thresh. in general, setting slopeBelow to be lower than slopeAbove results in expansion of dynamic range.

    .slopeAbove - ( float, READ/WRITE )  
        determines the slope of the output gain vs the input envelope's level in dB when the envelope is above  thresh. For example, if slopeAbove were 0.5, thresh were 0.1, and the envelope's value were 0.2, the envelope's amplitude would be about 6 dB above thresh, so a gain of -3 dB would be applied to bring the output signal's amplitude up to only 3 dB above thresh. in general, setting slopeAbove to be lower than slopeBelow results in compression of dynamic range

    .sideInput - ( float, READ/WRITE )
        if externalSideInput is set to true,  replaces the signal being processed as the input to the amplitude  envelope. see dynoduck.ck for an example of using an external side chain.  

    .externalSideInput - ( int, READ/WRITE )
        set to true (1) to cue the amplitude envelope off of sideInput instead of the input signal. note that this means you will need to manually set sideInput every so often. if false (0), the amplitude envelope represents the amplitude of the input signal whose dynamics are being processed. 
  
see dynoduck.ck for an example of using an external side chain.  
    
  
  
## sound files  
  
  
### [ugen]: SndBuf  

sound buffer ( interpolating )  , also `SndBuf2` for stereo files.
  
reads from a variety of file formats  
see examples: sndbuf.ck  
  
(control parameters)  
  
    .read - ( string , WRITE only ) - loads file for reading
    .chunks - ( int, READ/WRITE ) 
        - size of chunk (# of frames) to read on-demand; 
        - 0 implies entire file, (default) 
        must be set before reading to take effect.
    .samples - ( int , READ only ) - get number of samples
    .length - ( dur, READ only ) - get length as duration
    .channels - ( int , READ only ) - get number of channels
    .pos - ( int , READ/WRITE ) - set position ( 0 < p < .samples )
    .rate - ( float , READ/WRITE ) - set/get playback rate ( relative to file's natural speed )
    .interp - ( int , READ/WRITE ) - set/get interpolation ( 0=drop, 1=linear, 2=sinc )
    .loop - ( int , READ/WRITE ) - toggle looping
    .freq - ( float , READ/WRITE ) - set/get loop rate ( file loops / second )
    .phase - ( float , READ/WRITE ) - set/get phase position ( 0-1 )
    .channel - ( int , READ/WRITE ) - sel/get channel ( 0 < p < .channels )
    .phaseOffset - ( float , READ/WRITE ) - set/get a phase offset
    .write - ( string , WRITE only ) - loads a file for writing ( or not )
  
  

## oscillators  


### [ugen]: Phasor  

phasor - simple ramp generator ( 0 to 1 )
can be used as a phase control.
(control parameters)
.freq - ( float , READ/WRITE ) - oscillator frequency (Hz), phase-matched
.sfreq - ( float , READ/WRITE ) - oscillator frequency (Hz)
.phase - ( float , READ/WRITE ) - current phase
.sync - ( int , READ/WRITE ) - (0) sync frequency to input, (1) sync phase to input, (2) fm synth
.width - ( float , READ/WRITE ) - set duration of the ramp in each cycle. ( default 1.0)

[ugen]: SinOsc
sine oscillator
see examples: whirl.ck
(control parameters)
.freq - ( float , READ/WRITE ) - oscillator frequency (Hz), phase-matched
.sfreq - ( float , READ/WRITE ) - oscillator frequency (Hz)
.phase - ( float , READ/WRITE ) - current phase
.sync - ( int , READ/WRITE ) - (0) sync frequency to input, (1) sync phase to input, (2) fm synth

[ugen]: PulseOsc
pulse oscillators
a pulse wave oscillator with variable width.
(control parameters)
.freq - ( float , READ/WRITE ) - oscillator frequency (Hz), phase-matched
.sfreq - ( float , READ/WRITE ) - oscillator frequency (Hz)
.phase - ( float , READ/WRITE ) - current phase
.sync - ( int , READ/WRITE ) - (0) sync frequency to input, (1) sync phase to input, (2) fm synth
.width - ( float , READ/WRITE ) - length of duty cycle ( 0-1 )

[ugen]: SqrOsc
square wave oscillator ( pulse with fixed width of 0.5 )
(control parameters)
.freq - ( float , READ/WRITE ) - oscillator frequency (Hz), phase-matched
.sfreq - ( float , READ/WRITE ) - oscillator frequency (Hz)
.phase - ( float , READ/WRITE ) - current phase
.sync - ( int , READ/WRITE ) - (0) sync frequency to input, (1) sync phase to input, (2) fm synth
.width - ( int , READ/WRITE ) - length of duty cycle ( 0 to 1 )

[ugen]: TriOsc
triangle wave oscillator
(control parameters)
.freq - ( float , READ/WRITE ) - oscillator frequency (Hz), phase-matched
.sfreq - ( float , READ/WRITE ) - oscillator frequency (Hz)
.phase - ( float , READ/WRITE ) - current phase
.sync - ( int , READ/WRITE ) - (0) sync frequency to input, (1) sync phase to input, (2) fm synth
.width - ( float , READ/WRITE ) - control midpoint of triangle ( 0 to 1 )

[ugen]: SawOsc
sawtooth wave oscillator ( triangle, width forced to 0.0 or 1.0 )
(control parameters)
.freq - ( float , READ/WRITE ) - oscillator frequency (Hz), phase-matched
.sfreq - ( float , READ/WRITE ) - oscillator frequency (Hz)
.phase - ( float , READ/WRITE ) - current phase
.sync - ( int , READ/WRITE ) - (0) sync frequency to input, (1) sync phase to input, (2) fm synth
.width - ( float , READ/WRITE ) - increasing ( w > 0.5 ) or decreasing ( w < 0.5 )

[ugen]: GenX
base class for classic MusicN lookup table unit generators
see examples: readme-GenX.ck
Ported from rtcmix. See http://www.music.columbia.edu/cmix/makegens.html for more information on the GenX family of UGens. Currently coefficients past the 100th are ignored.

Lookup can either be done using the lookup() function, or by driving the table with an input UGen, typically a Phasor. For an input signal between [ -1, 1 ], using the absolute value for [ -1, 0 ), GenX will output the table value indexed by the current input.

(control parameters)
.lookup( float i ) - ( float , READ ONLY ) - returns lookup table value at index i [ -1, 1 ]; absolute value is used in the range [ -1, 0 )
.coefs - ( float [ ] , WRITE ONLY ) - set lookup table coefficients; meaning is dependent on subclass
[ugen]: Gen5
exponential line segment lookup table table generator
see examples: Gen5-test.ck
Constructs a lookup table composed of sequential exponential curves. For a table with N curves, starting value of y', and value yn for lookup index xn, set the coefficients to [ y', y0, x0, ..., yN-1, xN-1 ]. Note that there must be an odd number of coefficients. If an even number of coefficients is specified, behavior is undefined. The sum of xn for 0 ≤ n < N must be 1. yn = 0 is approximated as 0.000001 to avoid strange results arising from the nature of exponential curves.

extends GenX
(control parameters)
( see GenX )
[ugen]: Gen7
line segment lookup table table generator
see examples: Gen7-test.ck
Constructs a lookup table composed of sequential line segments. For a table with N lines, starting value of y', and value yn for lookup index xn, set the coefficients to [ y', y0, x0, ..., yN-1, xN-1 ]. Note that there must be an odd number of coefficients. If an even number of coefficients is specified, behavior is undefined. The sum of xn for 0 ≤ n < N must be 1.

extends GenX
(control parameters)
( see GenX )
[ugen]: Gen9
sinusoidal lookup table with harmonic ratio, amplitude, and phase control
see examples: Gen9-test.ck
Constructs a lookup table of partials with specified amplitudes, phases, and harmonic ratios to the fundamental. Coefficients are specified in triplets of [ ratio, amplitude, phase ] arranged in a single linear array.

extends GenX
(control parameters)
( see GenX )
[ugen]: Gen10
sinusoidal lookup table with partial amplitude control
see examples: Gen10-test.ck
Constructs a lookup table of harmonic partials with specified amplitudes. The amplitude of partial n is specified by the nth element of the coefficients. For example, setting coefs to [ 1 ] will produce a sine wave.

extends GenX
(control parameters)
( see GenX )
[ugen]: Gen17
chebyshev polynomial lookup table
see examples: Gen17-test.ck
Constructs a Chebyshev polynomial wavetable with harmonic partials of specified weights. The weight of partial n is specified by the nth element of the coefficients.

Primarily used for waveshaping, driven by a SinOsc instead of a Phasor. See http://crca.ucsd.edu/~msp/techniques/v0.08/book-html/node74.html and http://en.wikipedia.org/wiki/Distortion_synthesis for more information.

extends GenX
(control parameters)
( see GenX )
[ugen]: CurveTable
flexible curve/line segment table generator
see examples: GenX-CurveTable-test.ck
Constructs a wavetable composed of segments of variable times, values, and curvatures. Coefficients are specified as a single linear array of triplets of [ time, value, curvature ] followed by a final duple of [ time, value ] to specify the final value of the table. time values are expressed in unitless, ascending values. For curvature equal to 0, the segment is a line; for curvature less than 0, the segment is a convex curve; for curvature greater than 0, the segment is a concave curve.

extends GenX
(control parameters)
( see GenX )
[ugen]: LiSa
live sampling utility.
LiSa provides basic live sampling functionality.
An internal buffer stores samples chucked to LiSa's input.
Segments of this buffer can be played back, with ramping and 
speed/direction control.
Multiple voice facility is built in, allowing for a single 
LiSa object to serve as a source for sample layering and 
granular textures.
by Dan Trueman (2007)
see LiSa Examples wiki for more, 
and also a slowly growing tutorial 
(control parameters)
.duration - ( dur , READ/WRITE ) - sets buffer size; required to allocate memory, also resets all parameter values to default
.record - ( int , READ/WRITE ) - turns recording on and off
.getVoice - ( READ ) - returns the voice number of the next available voice
.maxVoices - ( int , READ/WRITE ) - sets the maximum number of voices allowable; 10 by default (200 is the current hardwired internal limit)
.play - ( int, WRITE ) - turn on/off sample playback (voice 0)
.play - ( int voice, int, WRITE) - for particular voice (arg 1), turn on/off sample playback
.rampUp - ( dur, WRITE ) - turn on sample playback, with ramp (voice 0)
.rampUp - ( int voice dur, WRITE ) - for particular voice (arg 1), turn on sample playback, with ramp
.rampDown - ( dur, WRITE ) - turn off sample playback, with ramp (voice 0)
.rampDown - ( int voice, dur, WRITE ) - for particular voice (arg 1), turn off sample playback, with ramp
.rate - ( float, WRITE ) - set playback rate (voice 0). Note that the int/float type for this method will determine whether the rate is being set (float, for voice 0) or read (int, for voice number)
.rate - ( int voice, float, WRITE ) - for particular voice (arg 1), set playback rate
.rate - ( READ ) - get playback rate (voice 0)
.rate - ( int voice, READ ) - for particular voice (arg 1), get playback rate. Note that the int/float type for this method will determine whether the rate is being set (float, for voice 0) or read (int, for voice number)
.playPos - ( READ ) - get playback position (voice 0)
.playPos - ( int voice, READ ) - for particular voice (arg 1), get playback position
.playPos - ( dur, WRITE ) - set playback position (voice 0)
.playPos - ( int voice, dur, WRITE ) - for particular voice (arg 1), set playback position
.recPos - ( dur, READ/WRITE ) - get/set record position
.recRamp - ( dur , READ/WRITE ) - set ramping when recording (from 0 to loopEndRec)
.loopRec - ( int, READ/WRITE ) - turn on/off loop recording
.loopEndRec - ( dur, READ/WRITE ) - set end point in buffer for loop recording
.loopStart - ( dur , READ/WRITE ) - set loop starting point for playback (voice 0). only applicable when 1 => loop.
.loopStart - ( int voice, dur , WRITE ) - for particular voice (arg 1), set loop starting point for playback. only applicable when .loop(voice, 1).
.loopEnd - ( dur , READ/WRITE ) - set loop ending point for playback (voice 0). only applicable when 1 => loop.
.loopEnd - ( int voice, dur , WRITE ) - for particular voice (arg 1), set loop ending point for playback. only applicable when .loop(voice, 1).
.loop - ( int , READ/WRITE ) - turn on/off looping (voice 0)
.loop - ( int voice, int, READ/WRITE ) - for particular voice (arg 1), turn on/off looping
.bi - ( int , READ/WRITE ) - turn on/off bidirectional playback (voice 0)
.bi - ( int voice, int , WRITE ) - for particular voice (arg 1), turn on/off bidirectional playback
.voiceGain - ( float , READ/WRITE ) - set playback gain (voice 0)
.voiceGain - ( int voice, float , WRITE ) - for particular voice (arg 1), set gain
.feedback - ( float , READ/WRITE ) - get/set feedback amount when overdubbing (loop recording; how much to retain)
.valueAt - ( dur, READ ) - get value directly from record buffer
.valueAt - ( sample, dur, WRITE ) - set value directly in record buffer
.sync - (int, READ/WRITE) - set input mode; (0) input is recorded to internal buffer, (1) input sets playback position [0,1] (phase value between loopStart and loopEnd for all active voices), (2) input sets playback position, interpreted as a time value in samples (only works with voice 0)
.track - (int, READ/WRITE) - identical to sync
.clear - clear recording buffer
network
[ugen]: netout
UDP-based network audio transmitter
(control parameters)
.addr - ( string , READ/WRITE ) - target address
.port - ( int , READ/WRITE ) - target port
.size - ( int , READ/WRITE ) - packet size
.name - ( string , READ/WRITE ) - name?
[ugen]: netin
UDP-based network audio receiver
(control parameters)
.port - ( int , READ/WRITE ) - set port to receive
.name - ( string , READ/WRITE ) - name?
stereo to mono
[ugen]: Pan2
spread mono signal to stereo
see examples: moe2.ck
(control parameters)
.left - ( UGen ) - left (mono) channel out
.right - ( UGen ) - right (mono) channel out
.pan - ( float , READ/WRITE ) - pan location value ( -1 to 1 )
[ugen]: Mix2
mix stereo input down to mono channel
(control parameters)
.left - ( UGen ) - left (mono) channel in
.right - ( UGen ) - right (mono) channel in
.pan - ( float , READ/WRITE ) - mix parameter value ( 0 to 1 )
STK
stk - instruments
[ugen]: StkInstrument (Imported from Instrmnt)
Super-class for STK instruments.
    The following UGens subclass StkInstrument:
       - BandedWG
       - BlowBotl
       - BlowHole
       - Bowed
       - Brass
       - Clarinet
       - Flute
       - FM (and all its subclasses: BeeThree, FMVoices,
             HevyMetl, PercFlut, Rhodey, TubeBell, Wurley)
       - Mandolin
       - ModalBar
       - Moog
       - Saxofony
       - Shakers
       - Sitar
       - StifKarp
       - VoicForm
(control parameters)
.noteOn - ( float velocity ) - trigger note on
.noteOff - ( float velocity ) - trigger note off
.freq - ( float frequency ) - set/get frequency (Hz)
.controlChange - ( int number, float value ) - assert control change - numbers are instrument specific, value range: [0.0 - 128.0]
[ugen]: BandedWG (STK Import)
Banded waveguide modeling class.
    This class uses banded waveguide techniques to
    model a variety of sounds, including bowed
    bars, glasses, and bowls.  For more
    information, see Essl, G. and Cook, P. "Banded
    Waveguides: Towards Physical Modelling of Bar
    Percussion Instruments", Proceedings of the
    1999 International Computer Music Conference.

    Control Change Numbers: 
       - Bow Pressure = 2
       - Bow Motion = 4
       - Strike Position = 8 (not implemented)
       - Vibrato Frequency = 11
       - Gain = 1
       - Bow Velocity = 128
       - Set Striking = 64
       - Instrument Presets = 16
         - Uniform Bar = 0
         - Tuned Bar = 1
         - Glass Harmonica = 2
         - Tibetan Bowl = 3

    by Georg Essl, 1999 - 2002.
    Modified for Stk 4.0 by Gary Scavone.
extends StkInstrument
(control parameters)
.bowPressure - ( float , READ/WRITE ) - bow pressure [0.0 - 1.0]
.bowMotion - ( float , READ/WRITE ) - bow motion [0.0 - 1.0]
.bowRate - ( float , READ/WRITE ) - bow attack rate (sec)
.strikePosition - ( float , READ/WRITE ) - strike Position [0.0 - 1.0]
.integrationConstant - ( float , READ/WRITE ) - ?? [0.0 - 1.0]
.modesGain - ( float , READ/WRITE ) - amplitude for modes [0.0 - 1.0]
.preset - ( int , READ/WRITE ) - instrument presets (0 - 3, see above)
.pluck - ( float , WRITE only ) - pluck instrument [0.0 - 1.0]
.startBowing - ( float , WRITE only ) - start bowing [0.0 - 1.0]
.stopBowing - ( float , WRITE only ) - stop bowing [0.0 - 1.0]
(inherited from StkInstrument)
.noteOn - ( float velocity ) - trigger note on
.noteOff - ( float velocity ) - trigger note off
.freq - ( float frequency ) - set/get frequency (Hz)
.controlChange - ( int number, float value ) - assert control change
[ugen]: BlowBotl (STK Import)
STK blown bottle instrument class.
    This class implements a helmholtz resonator
    (biquad filter) with a polynomial jet
    excitation (a la Cook).

    Control Change Numbers: 
       - Noise Gain = 4
       - Vibrato Frequency = 11
       - Vibrato Gain = 1
       - Volume = 128

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
extends StkInstrument
(control parameters)
.noiseGain - ( float , READ/WRITE ) - noise component gain [0.0 - 1.0]
.vibratoFreq - ( float , READ/WRITE ) - vibrato frequency (Hz)
.vibratoGain - ( float , READ/WRITE ) - vibrato gain [0.0 - 1.0]
.volume - ( float , READ/WRITE ) - yet another volume knob [0.0 - 1.0]
.rate - ( float , READ/WRITE ) - rate of attack (sec)
.startBlowing - ( float , WRITE only ) - start blowing [0.0 - 1.0]
.stopBlowing - ( float , WRITE only ) - stop blowing [0.0 - 1.0]
(inherited from StkInstrument)
.noteOn - ( float velocity ) - trigger note on
.noteOff - ( float velocity ) - trigger note off
.freq - ( float frequency ) - set/get frequency (Hz)
.controlChange - ( int number, float value ) - assert control change
[ugen]: BlowHole (STK Import)
STK clarinet physical model with one
           register hole and one tonehole.

    This class is based on the clarinet model,
    with the addition of a two-port register hole
    and a three-port dynamic tonehole
    implementation, as discussed by Scavone and
    Cook (1998).

    In this implementation, the distances between
    the reed/register hole and tonehole/bell are
    fixed.  As a result, both the tonehole and
    register hole will have variable influence on
    the playing frequency, which is dependent on
    the length of the air column.  In addition,
    the highest playing freqeuency is limited by
    these fixed lengths.
    This is a digital waveguide model, making its
    use possibly subject to patents held by Stanford
    University, Yamaha, and others.

    Control Change Numbers: 
       - Reed Stiffness = 2
       - Noise Gain = 4
       - Tonehole State = 11
       - Register State = 1
       - Breath Pressure = 128

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
extends StkInstrument
(control parameters)
.reed - ( float , READ/WRITE ) - reed stiffness [0.0 - 1.0]
.noiseGain - ( float , READ/WRITE ) - noise component gain [0.0 - 1.0]
.tonehole - ( float , READ/WRITE ) - tonehole size [0.0 - 1.0]
.vent - ( float , READ/WRITE ) - vent frequency [0.0 - 1.0]
.pressure - ( float , READ/WRITE ) - pressure [0.0 - 1.0]
.startBlowing - ( float , WRITE only ) - start blowing [0.0 - 1.0]
.stopBlowing - ( float , WRITE only ) - stop blowing [0.0 - 1.0]
.rate - ( float , READ/WRITE ) - rate of attack (sec)
(inherited from StkInstrument)
.noteOn - ( float velocity ) - trigger note on
.noteOff - ( float velocity ) - trigger note off
.freq - ( float frequency ) - set/get frequency (Hz)
.controlChange - ( int number, float value ) - assert control change
[ugen]: Bowed (STK Import)
STK bowed string instrument class.
    This class implements a bowed string model, a
    la Smith (1986), after McIntyre, Schumacher,
    Woodhouse (1983).

    This is a digital waveguide model, making its
    use possibly subject to patents held by
    Stanford University, Yamaha, and others.

    Control Change Numbers: 
       - Bow Pressure = 2
       - Bow Position = 4
       - Vibrato Frequency = 11
       - Vibrato Gain = 1
       - Volume = 128

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
extends StkInstrument
(control parameters)
.bowPressure - ( float , READ/WRITE ) - bow pressure [0.0 - 1.0]
.bowPosition - ( float , READ/WRITE ) - bow position [0.0 - 1.0]
.vibratoFreq - ( float , READ/WRITE ) - vibrato frequency (Hz)
.vibratoGain - ( float , READ/WRITE ) - vibrato gain [0.0 - 1.0]
.volume - ( float , READ/WRITE ) - volume [0.0 - 1.0]
.startBowing - ( float , WRITE only ) - start bowing [0.0 - 1.0]
.stopBowing - ( float , WRITE only ) - stop bowing [0.0 - 1.0]
.rate - ( float , READ/WRITE ) - rate of attack (sec)
(inherited from StkInstrument)
.noteOn - ( float velocity ) - trigger note on
.noteOff - ( float velocity ) - trigger note off
.freq - ( float frequency ) - set/get frequency (Hz)
.controlChange - ( int number, float value ) - assert control change
[ugen]: Brass (STK Import)
STK simple brass instrument class.
    This class implements a simple brass instrument
    waveguide model, a la Cook (TBone, HosePlayer).

    This is a digital waveguide model, making its
    use possibly subject to patents held by
    Stanford University, Yamaha, and others.

    Control Change Numbers: 
       - Lip Tension = 2
       - Slide Length = 4
       - Vibrato Frequency = 11
       - Vibrato Gain = 1
       - Volume = 128

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
extends StkInstrument
(control parameters)
.lip - ( float , READ/WRITE ) - lip tension [0.0 - 1.0]
.slide - ( float , READ/WRITE ) - slide length [0.0 - 1.0]
.vibratoFreq - ( float , READ/WRITE ) - vibrato frequency (Hz)
.vibratoGain - ( float , READ/WRITE ) - vibrato gain [0.0 - 1.0]
.volume - ( float , READ/WRITE ) - volume [0.0 - 1.0]
.clear - ( float , WRITE only ) - clear instrument
.startBlowing - ( float , WRITE only ) - start blowing [0.0 - 1.0]
.stopBlowing - ( float , WRITE only ) - stop blowing [0.0 - 1.0]
.rate - ( float , READ/WRITE ) - rate of attack (sec)
(inherited from StkInstrument)
.noteOn - ( float velocity ) - trigger note on
.noteOff - ( float velocity ) - trigger note off
.freq - ( float frequency ) - set/get frequency (Hz)
.controlChange - ( int number, float value ) - assert control change
[ugen]: Clarinet (STK Import)
STK clarinet physical model class.
    This class implements a simple clarinet
    physical model, as discussed by Smith (1986),
    McIntyre, Schumacher, Woodhouse (1983), and
    others.

    This is a digital waveguide model, making its
    use possibly subject to patents held by Stanford
    University, Yamaha, and others.

    Control Change Numbers: 
       - Reed Stiffness = 2
       - Noise Gain = 4
       - Vibrato Frequency = 11
       - Vibrato Gain = 1
       - Breath Pressure = 128

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
extends StkInstrument
(control parameters)
.reed - ( float , READ/WRITE ) - reed stiffness [0.0 - 1.0]
.noiseGain - ( float , READ/WRITE ) - noise component gain [0.0 - 1.0]
.clear - ( ) - clear instrument
.vibratoFreq - ( float , READ/WRITE ) - vibrato frequency (Hz)
.vibratoGain - ( float , READ/WRITE ) - vibrato gain [0.0 - 1.0]
.pressure - ( float , READ/WRITE ) - pressure/volume [0.0 - 1.0]
.startBlowing - ( float , WRITE only ) - start blowing [0.0 - 1.0]
.stopBlowing - ( float , WRITE only ) - stop blowing [0.0 - 1.0]
.rate - ( float , READ/WRITE ) - rate of attack (sec)
(inherited from StkInstrument)
.noteOn - ( float velocity ) - trigger note on
.noteOff - ( float velocity ) - trigger note off
.freq - ( float frequency ) - set/get frequency (Hz)
.controlChange - ( int number, float value ) - assert control change
[ugen]: Flute (STK Import)
STK flute physical model class.
    This class implements a simple flute
    physical model, as discussed by Karjalainen,
    Smith, Waryznyk, etc.  The jet model uses
    a polynomial, a la Cook.

    This is a digital waveguide model, making its
    use possibly subject to patents held by Stanford
    University, Yamaha, and others.

    Control Change Numbers: 
       - Jet Delay = 2
       - Noise Gain = 4
       - Vibrato Frequency = 11
       - Vibrato Gain = 1
       - Breath Pressure = 128

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
extends StkInstrument
(control parameters)
.jetDelay - ( float , READ/WRITE ) - jet delay [...]
.jetReflection - ( float , READ/WRITE ) - jet reflection [...]
.endReflection - ( float , READ/WRITE ) - end delay [...]
.noiseGain - ( float , READ/WRITE ) - noise component gain [0.0 - 1.0]
.vibratoFreq - ( float , READ/WRITE ) - vibrato frequency (Hz)
.vibratoGain - ( float , READ/WRITE ) - vibrato gain [0.0 - 1.0]
.pressure - ( float , READ/WRITE ) - pressure/volume [0.0 - 1.0]
.clear - ( ) - clear instrument
.startBlowing - ( float , WRITE only ) - start blowing [0.0 - 1.0]
.stopBlowing - ( float , WRITE only ) - stop blowing [0.0 - 1.0]
.rate - ( float , READ/WRITE ) - rate of attack (sec)
(inherited from StkInstrument)
.noteOn - ( float velocity ) - trigger note on
.noteOff - ( float velocity ) - trigger note off
.freq - ( float frequency ) - set/get frequency (Hz)
.controlChange - ( int number, float value ) - assert control change
[ugen]: Mandolin (STK Import)
STK mandolin instrument model class.
see examples: mand-o-matic.ck
    This class inherits from PluckTwo and uses
    "commuted synthesis" techniques to model a
    mandolin instrument.

    This is a digital waveguide model, making its
    use possibly subject to patents held by
    Stanford University, Yamaha, and others.
    Commuted Synthesis, in particular, is covered
    by patents, granted, pending, and/or
    applied-for.  All are assigned to the Board of
    Trustees, Stanford University.  For
    information, contact the Office of Technology
    Licensing, Stanford University.

    Control Change Numbers: 
       - Body Size = 2
       - Pluck Position = 4
       - String Sustain = 11
       - String Detuning = 1
       - Microphone Position = 128

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
extends StkInstrument
(control parameters)
.bodySize - ( float , READ/WRITE ) - body size (percentage)
.pluckPos - ( float , READ/WRITE ) - pluck position [0.0 - 1.0]
.stringDamping - ( float , READ/WRITE ) - string damping [0.0 - 1.0]
.stringDetune - ( float , READ/WRITE ) - detuning of string pair [0.0 - 1.0]
.afterTouch - ( float , WRITE only ) - aftertouch (currently unsupported)
.pluck - ( float , WRITE only ) - pluck instrument [0.0 - 1.0]
(inherited from StkInstrument)
.noteOn - ( float velocity ) - trigger note on
.noteOff - ( float velocity ) - trigger note off
.freq - ( float frequency ) - set/get frequency (Hz)
.controlChange - ( int number, float value ) - assert control change
[ugen]: ModalBar (STK Import)
STK resonant bar instrument class.
see examples: mode-o-matic.ck
    This class implements a number of different
    struck bar instruments.  It inherits from the
    Modal class.

    Control Change Numbers: 
       - Stick Hardness = 2
       - Stick Position = 4
       - Vibrato Gain = 11
       - Vibrato Frequency = 7
       - Direct Stick Mix = 1
       - Volume = 128
       - Modal Presets = 16
         - Marimba = 0
         - Vibraphone = 1
         - Agogo = 2
         - Wood1 = 3
         - Reso = 4
         - Wood2 = 5
         - Beats = 6
         - Two Fixed = 7
         - Clump = 8

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
extends StkInstrument
(control parameters)
.stickHardness - ( float , READ/WRITE ) - stick hardness [0.0 - 1.0]
.strikePosition - ( float , READ/WRITE ) - strike position [0.0 - 1.0]
.vibratoFreq - ( float , READ/WRITE ) - vibrato frequency (Hz)
.vibratoGain - ( float , READ/WRITE ) - vibrato gain [0.0 - 1.0]
.directGain - ( float , READ/WRITE ) - direct gain [0.0 - 1.0]
.masterGain - ( float , READ/WRITE ) - master gain [0.0 - 1.0]
.volume - ( float , READ/WRITE ) - volume [0.0 - 1.0]
.preset - ( int , READ/WRITE ) - choose preset (see above)
.strike - ( float , WRITE only ) - strike bar [0.0 - 1.0]
.damp - ( float , WRITE only ) - damp bar [0.0 - 1.0]
.clear - ( ) - reset [none]
.mode - ( int , READ/WRITE ) - select mode [0.0 - 1.0]
.modeRatio - ( float , READ/WRITE ) - edit selected mode ratio [...]
.modeRadius - ( float , READ/WRITE ) - edit selected mode radius [0.0 - 1.0]
.modeGain - ( float , READ/WRITE ) - edit selected mode gain [0.0 - 1.0]
(inherited from StkInstrument)
.noteOn - ( float velocity ) - trigger note on
.noteOff - ( float velocity ) - trigger note off
.freq - ( float frequency ) - set/get frequency (Hz)
.controlChange - ( int number, float value ) - assert control change
[ugen]: Moog (STK Import)
STK moog-like swept filter sampling synthesis class.
see examples: moogie.ck
    This instrument uses one attack wave, one
    looped wave, and an ADSR envelope (inherited
    from the Sampler class) and adds two sweepable
    formant (FormSwep) filters.

    Control Change Numbers: 
       - Filter Q = 2
       - Filter Sweep Rate = 4
       - Vibrato Frequency = 11
       - Vibrato Gain = 1
       - Gain = 128

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
extends StkInstrument
(control parameters)
.filterQ - ( float , READ/WRITE ) - filter Q value [0.0 - 1.0]
.filterSweepRate - ( float , READ/WRITE ) - filter sweep rate [0.0 - 1.0]
.vibratoFreq - ( float , READ/WRITE ) - vibrato frequency (Hz)
.vibratoGain - ( float , READ/WRITE ) - vibrato gain [0.0 - 1.0]
.afterTouch - ( float , WRITE only ) - aftertouch [0.0 - 1.0]
(inherited from StkInstrument)
.noteOn - ( float velocity ) - trigger note on
.noteOff - ( float velocity ) - trigger note off
.freq - ( float frequency ) - set/get frequency (Hz)
.controlChange - ( int number, float value ) - assert control change
[ugen]: Saxofony (STK Import)
STK faux conical bore reed instrument class.
    This class implements a "hybrid" digital
    waveguide instrument that can generate a
    variety of wind-like sounds.  It has also been
    referred to as the "blowed string" model.  The
    waveguide section is essentially that of a
    string, with one rigid and one lossy
    termination.  The non-linear function is a
    reed table.  The string can be "blown" at any
    point between the terminations, though just as
    with strings, it is impossible to excite the
    system at either end.  If the excitation is
    placed at the string mid-point, the sound is
    that of a clarinet.  At points closer to the
    "bridge", the sound is closer to that of a
    saxophone.  See Scavone (2002) for more details.

    This is a digital waveguide model, making its
    use possibly subject to patents held by Stanford
    University, Yamaha, and others.

    Control Change Numbers: 
       - Reed Stiffness = 2
       - Reed Aperture = 26
       - Noise Gain = 4
       - Blow Position = 11
       - Vibrato Frequency = 29
       - Vibrato Gain = 1
       - Breath Pressure = 128

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
extends StkInstrument
(control parameters)
.stiffness - ( float , READ/WRITE ) - reed stiffness [0.0 - 1.0]
.aperture - ( float , READ/WRITE ) - reed aperture [0.0 - 1.0]
.pressure - ( float , READ/WRITE ) - pressure/volume [0.0 - 1.0]
.vibratoFreq - ( float , READ/WRITE ) - vibrato frequency (Hz)
.vibratoGain - ( float , READ/WRITE ) - vibrato gain [0.0 - 1.0]
.noiseGain - ( float , READ/WRITE ) - noise component gain [0.0 - 1.0]
.blowPosition - ( float , READ/WRITE ) - lip stiffness [0.0 - 1.0]
.clear - ( ) - clear instrument
.startBlowing - ( float , WRITE only ) - start blowing [0.0 - 1.0]
.stopBlowing - ( float , WRITE only ) - stop blowing [0.0 - 1.0]
.rate - ( float , READ/WRITE ) - rate of attack (sec)
(inherited from StkInstrument)
.noteOn - ( float velocity ) - trigger note on
.noteOff - ( float velocity ) - trigger note off
.freq - ( float frequency ) - set/get frequency (Hz)
.controlChange - ( int number, float value ) - assert control change
[ugen]: Shakers (STK Import)
PhISEM and PhOLIES class.
see examples: shake-o-matic.ck
    PhISEM (Physically Informed Stochastic Event
    Modeling) is an algorithmic approach for
    simulating collisions of multiple independent
    sound producing objects.  This class is a
    meta-model that can simulate a Maraca, Sekere,
    Cabasa, Bamboo Wind Chimes, Water Drops,
    Tambourine, Sleighbells, and a Guiro.

    PhOLIES (Physically-Oriented Library of
    Imitated Environmental Sounds) is a similar
    approach for the synthesis of environmental
    sounds.  This class implements simulations of
    breaking sticks, crunchy snow (or not), a
    wrench, sandpaper, and more.

    Control Change Numbers: 
       - Shake Energy = 2
       - System Decay = 4
       - Number Of Objects = 11
       - Resonance Frequency = 1
       - Shake Energy = 128
       - Instrument Selection = 1071
        - Maraca = 0
        - Cabasa = 1
        - Sekere = 2
        - Guiro = 3
        - Water Drops = 4
        - Bamboo Chimes = 5
        - Tambourine = 6
        - Sleigh Bells = 7
        - Sticks = 8
        - Crunch = 9
        - Wrench = 10
        - Sand Paper = 11
        - Coke Can = 12
        - Next Mug = 13
        - Penny + Mug = 14
        - Nickle + Mug = 15
        - Dime + Mug = 16
        - Quarter + Mug = 17
        - Franc + Mug = 18
        - Peso + Mug = 19
        - Big Rocks = 20
        - Little Rocks = 21
        - Tuned Bamboo Chimes = 22

    by Perry R. Cook, 1996 - 1999.
extends StkInstrument
(control parameters)
.preset - ( int , READ/WRITE ) - select instrument (0 - 22; see above)
.energy - ( float , READ/WRITE ) - shake energy [0.0 - 1.0]
.decay - ( float , READ/WRITE ) - system decay [0.0 - 1.0]
.objects - ( float , READ/WRITE ) - number of objects [0.0 - 128.0]
(inherited from StkInstrument)
.noteOn - ( float velocity ) - trigger note on
.noteOff - ( float velocity ) - trigger note off
.freq - ( float frequency ) - set/get frequency (Hz)
.controlChange - ( int number, float value ) - assert control change
[ugen]: Sitar (STK Import)
STK sitar string model class.
    This class implements a sitar plucked string
    physical model based on the Karplus-Strong
    algorithm.

    This is a digital waveguide model, making its
    use possibly subject to patents held by
    Stanford University, Yamaha, and others.
    There exist at least two patents, assigned to
    Stanford, bearing the names of Karplus and/or
    Strong.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
extends StkInstrument
(control parameters)
.pluck - ( float , WRITE only ) - pluck string [0.0 - 1.0]
.clear - ( ) - reset
(inherited from StkInstrument)
.noteOn - ( float velocity ) - trigger note on
.noteOff - ( float velocity ) - trigger note off
.freq - ( float frequency ) - set/get frequency (Hz)
.controlChange - ( int number, float value ) - assert control change
[ugen]: StifKarp (STK Import)
STK plucked stiff string instrument.
see examples: stifkarp.ck
    This class implements a simple plucked string
    algorithm (Karplus Strong) with enhancements
    (Jaffe-Smith, Smith, and others), including
    string stiffness and pluck position controls.
    The stiffness is modeled with allpass filters.

    This is a digital waveguide model, making its
    use possibly subject to patents held by
    Stanford University, Yamaha, and others.

    Control Change Numbers:
       - Pickup Position = 4
       - String Sustain = 11
       - String Stretch = 1

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
extends StkInstrument
(control parameters)
.pickupPosition - ( float , READ/WRITE ) - pickup position [0.0 - 1.0]
.sustain - ( float , READ/WRITE ) - string sustain [0.0 - 1.0]
.stretch - ( float , READ/WRITE ) - string stretch [0.0 - 1.0]
.pluck - ( float , WRITE only ) - pluck string [0.0 - 1.0]
.baseLoopGain - ( float , READ/WRITE ) - ?? [0.0 - 1.0]
.clear - ( ) - reset instrument
(inherited from StkInstrument)
.noteOn - ( float velocity ) - trigger note on
.noteOff - ( float velocity ) - trigger note off
.freq - ( float frequency ) - set/get frequency (Hz)
.controlChange - ( int number, float value ) - assert control change
[ugen]: VoicForm (STK Import)
Four formant synthesis instrument.
see examples: voic-o-form.ck
    This instrument contains an excitation singing
    wavetable (looping wave with random and
    periodic vibrato, smoothing on frequency,
    etc.), excitation noise, and four sweepable
    complex resonances.

    Measured formant data is included, and enough
    data is there to support either parallel or
    cascade synthesis.  In the floating point case
    cascade synthesis is the most natural so
    that's what you'll find here.

    Control Change Numbers: 
       - Voiced/Unvoiced Mix = 2
       - Vowel/Phoneme Selection = 4
       - Vibrato Frequency = 11
       - Vibrato Gain = 1
       - Loudness (Spectral Tilt) = 128

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.

    Phoneme Names:
    "eee"  "ihh"  "ehh"  "aaa" 
    "ahh"  "aww"  "ohh"  "uhh" 
    "uuu"  "ooo"  "rrr"  "lll" 
    "mmm"  "nnn"  "nng"  "ngg" 
    "fff"  "sss"  "thh"  "shh" 
    "xxx"  "hee"  "hoo"  "hah" 
    "bbb"  "ddd"  "jjj"  "ggg" 
    "vvv"  "zzz"  "thz"  "zhh"
    
extends StkInstrument
(control parameters)
.phoneme - ( string , READ/WRITE ) - select phoneme ( see above )
.phonemeNum - ( int , READ/WRITE ) - select phoneme by number [0.0 - 128.0]
.speak - ( float , WRITE only ) - start singing [0.0 - 1.0]
.quiet - ( float , WRITE only ) - stop singing [0.0 - 1.0]
.voiced - ( float , READ/WRITE ) - set mix for voiced component [0.0 - 1.0]
.unVoiced - ( float , READ/WRITE ) - set mix for unvoiced component [0.0 - 1.0]
.pitchSweepRate - ( float , READ/WRITE ) - pitch sweep [0.0 - 1.0]
.voiceMix - ( float , READ/WRITE ) - voiced/unvoiced mix [0.0 - 1.0]
.vibratoFreq - ( float , READ/WRITE ) - vibrato frequency (Hz)
.vibratoGain - ( float , READ/WRITE ) - vibrato gain [0.0 - 1.0]
.loudness - ( float , READ/WRITE ) - 'loudness' of voice [0.0 - 1.0]
(inherited from StkInstrument)
.noteOn - ( float velocity ) - trigger note on
.noteOff - ( float velocity ) - trigger note off
.freq - ( float frequency ) - set/get frequency (Hz)
.controlChange - ( int number, float value ) - assert control change
stk - fm synths
[ugen]: FM (STK Import)
STK abstract FM synthesis base class.
    This class controls an arbitrary number of
    waves and envelopes, determined via a
    constructor argument.

    Control Change Numbers: 
       - Control One = 2
       - Control Two = 4
       - LFO Speed = 11
       - LFO Depth = 1
       - ADSR 2 & 4 Target = 128

    The basic Chowning/Stanford FM patent expired
    in 1995, but there exist follow-on patents,
    mostly assigned to Yamaha.  If you are of the
    type who should worry about this (making
    money) worry away.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
extends StkInstrument
(control parameters)
.lfoSpeed - ( float , READ/WRITE ) - modulation Speed (Hz)
.lfoDepth - ( float , READ/WRITE ) - modulation Depth [0.0 - 1.0]
.afterTouch - ( float , READ/WRITE ) - aftertouch [0.0 - 1.0]
.controlOne - ( float , READ/WRITE ) - control one [instrument specific]
.controlTwo - ( float , READ/WRITE ) - control two [instrument specific]
(inherited from StkInstrument)
.noteOn - ( float velocity ) - trigger note on
.noteOff - ( float velocity ) - trigger note off
.freq - ( float frequency ) - set/get frequency (Hz)
.controlChange - ( int number, float value ) - assert control change
[ugen]: BeeThree (STK Import)
STK Hammond-oid organ FM synthesis instrument.
    This class implements a simple 4 operator
    topology, also referred to as algorithm 8 of
    the TX81Z.

    \code
    Algorithm 8 is :
                     1 --.
                     2 -\|
                         +-> Out
                     3 -/|
                     4 --
    \endcode

    Control Change Numbers: 
       - Operator 4 (feedback) Gain = 2 (.controlOne)
       - Operator 3 Gain = 4 (.controlTwo)
       - LFO Speed = 11
       - LFO Depth = 1
       - ADSR 2 & 4 Target = 128

    The basic Chowning/Stanford FM patent expired
    in 1995, but there exist follow-on patents,
    mostly assigned to Yamaha.  If you are of the
    type who should worry about this (making
    money) worry away.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
extends FM
(control parameters)
( see super classes )
[ugen]: FMVoices (STK Import)
STK singing FM synthesis instrument.
    This class implements 3 carriers and a common
    modulator, also referred to as algorithm 6 of
    the TX81Z.

    \code
    Algorithm 6 is :
                        /->1 -\
                     4-|-->2 - +-> Out
                        \->3 -/
    \endcode

    Control Change Numbers: 
       - Vowel = 2 (.controlOne)
       - Spectral Tilt = 4 (.controlTwo)
       - LFO Speed = 11
       - LFO Depth = 1
       - ADSR 2 & 4 Target = 128

    The basic Chowning/Stanford FM patent expired
    in 1995, but there exist follow-on patents,
    mostly assigned to Yamaha.  If you are of the
    type who should worry about this (making
    money) worry away.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
extends FM
(control parameters)
.vowel - ( float , WRITE only ) - select vowel [0.0 - 1.0]
.spectralTilt - ( float , WRITE only ) - spectral tilt [0.0 - 1.0]
.adsrTarget - ( float , WRITE only ) - adsr targets [0.0 - 1.0]
[ugen]: HevyMetl (STK Import)
STK heavy metal FM synthesis instrument.
    This class implements 3 cascade operators with
    feedback modulation, also referred to as
    algorithm 3 of the TX81Z.

    Algorithm 3 is :     4--\
                    3-->2-- + -->1-->Out

    Control Change Numbers: 
       - Total Modulator Index = 2 (.controlOne)
       - Modulator Crossfade = 4 (.controlTwo)
       - LFO Speed = 11
       - LFO Depth = 1
       - ADSR 2 & 4 Target = 128

    The basic Chowning/Stanford FM patent expired
    in 1995, but there exist follow-on patents,
    mostly assigned to Yamaha.  If you are of the
    type who should worry about this (making
    money) worry away.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
extends FM
(control parameters)
( see super classes )
[ugen]: PercFlut (STK Import)
STK percussive flute FM synthesis instrument.
    This class implements algorithm 4 of the TX81Z.

    \code
    Algorithm 4 is :   4->3--\
                          2-- + -->1-->Out
    \endcode

    Control Change Numbers: 
       - Total Modulator Index = 2 (.controlOne)
       - Modulator Crossfade = 4 (.controlTwo)
       - LFO Speed = 11
       - LFO Depth = 1
       - ADSR 2 & 4 Target = 128

    The basic Chowning/Stanford FM patent expired
    in 1995, but there exist follow-on patents,
    mostly assigned to Yamaha.  If you are of the
    type who should worry about this (making
    money) worry away.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
extends FM
(control parameters)
( see super classes )
[ugen]: Rhodey (STK Import)
STK Fender Rhodes-like electric piano FM
see examples: rhodey.ck
           synthesis instrument.

    This class implements two simple FM Pairs
    summed together, also referred to as algorithm
    5 of the TX81Z.

    \code
    Algorithm 5 is :  4->3--\
                             + --> Out
                      2->1--/
    \endcode

    Control Change Numbers: 
       - Modulator Index One = 2 (.controlOne)
       - Crossfade of Outputs = 4 (.controlTwo)
       - LFO Speed = 11
       - LFO Depth = 1
       - ADSR 2 & 4 Target = 128

    The basic Chowning/Stanford FM patent expired
    in 1995, but there exist follow-on patents,
    mostly assigned to Yamaha.  If you are of the
    type who should worry about this (making
    money) worry away.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
extends FM
(control parameters)
( see super classes )
[ugen]: TubeBell (STK Import)
STK tubular bell (orchestral chime) FM
           synthesis instrument.

    This class implements two simple FM Pairs
    summed together, also referred to as algorithm
    5 of the TX81Z.

    \code
    Algorithm 5 is :  4->3--\
                             + --> Out
                      2->1--/
    \endcode

    Control Change Numbers: 
       - Modulator Index One = 2 (.controlOne)
       - Crossfade of Outputs = 4 (.controlTwo)
       - LFO Speed = 11
       - LFO Depth = 1
       - ADSR 2 & 4 Target = 128

    The basic Chowning/Stanford FM patent expired
    in 1995, but there exist follow-on patents,
    mostly assigned to Yamaha.  If you are of the
    type who should worry about this (making
    money) worry away.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
extends FM
(control parameters)
( see super classes )
[ugen]: Wurley (STK Import)
STK Wurlitzer electric piano FM
see examples: wurley.ck
           synthesis instrument.

    This class implements two simple FM Pairs
    summed together, also referred to as algorithm
    5 of the TX81Z.

    \code
    Algorithm 5 is :  4->3--\
                             + --> Out
                      2->1--/
    \endcode

    Control Change Numbers: 
       - Modulator Index One = 2 (.controlOne)
       - Crossfade of Outputs = 4 (.controlTwo)
       - LFO Speed = 11
       - LFO Depth = 1
       - ADSR 2 & 4 Target = 128

    The basic Chowning/Stanford FM patent expired
    in 1995, but there exist follow-on patents,
    mostly assigned to Yamaha.  If you are of the
    type who should worry about this (making
    money) worry away.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
extends FM
(control parameters)
( see super classes )
stk - delay
[ugen]: Delay (STK Import)
STK non-interpolating delay line class.
see examples: comb.ck 
    This protected Filter subclass implements
    a non-interpolating digital delay-line.
    A fixed maximum length of 4095 and a delay
    of zero is set using the default constructor.
    Alternatively, the delay and maximum length
    can be set during instantiation with an
    overloaded constructor.
    
    A non-interpolating delay line is typically
    used in fixed delay-length applications, such
    as for reverberation.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
(control parameters)
.delay - ( dur , READ/WRITE ) - length of delay
.max - ( dur , READ/WRITE ) - max delay (buffer size)
[ugen]: DelayA (STK Import)
STK allpass interpolating delay line class.
    This Delay subclass implements a fractional-
    length digital delay-line using a first-order
    allpass filter.  A fixed maximum length
    of 4095 and a delay of 0.5 is set using the
    default constructor.  Alternatively, the
    delay and maximum length can be set during
    instantiation with an overloaded constructor.

    An allpass filter has unity magnitude gain but
    variable phase delay properties, making it useful
    in achieving fractional delays without affecting
    a signal's frequency magnitude response.  In
    order to achieve a maximally flat phase delay
    response, the minimum delay possible in this
    implementation is limited to a value of 0.5.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
(control parameters)
.delay - ( dur , READ/WRITE ) - length of delay
.max - ( dur , READ/WRITE ) - max delay ( buffer size )
[ugen]: DelayL (STK Import)
STK linear interpolating delay line class.
see examples: i-robot.ck
    This Delay subclass implements a fractional-
    length digital delay-line using first-order
    linear interpolation.  A fixed maximum length
    of 4095 and a delay of zero is set using the
    default constructor.  Alternatively, the
    delay and maximum length can be set during
    instantiation with an overloaded constructor.

    Linear interpolation is an efficient technique
    for achieving fractional delay lengths, though
    it does introduce high-frequency signal
    attenuation to varying degrees depending on the
    fractional delay setting.  The use of higher
    order Lagrange interpolators can typically
    improve (minimize) this attenuation characteristic.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
(control parameters)
.delay - ( dur , READ/WRITE ) - length of delay
.max - ( dur , READ/WRITE ) - max delay ( buffer size )
[ugen]: Echo (STK Import)
STK echo effect class.
    This class implements a echo effect.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
(control parameters)
.delay - ( dur , READ/WRITE ) - length of echo
.max - ( dur , READ/WRITE ) - max delay
.mix - ( float , READ/WRITE ) - mix level ( wet/dry )
stk - envelopes
[ugen]: Envelope (STK Import)
STK envelope base class.
see examples: envelope.ck
    This class implements a simple envelope
    generator which is capable of ramping to
    a target value by a specified \e rate.
    It also responds to simple \e keyOn and
    \e keyOff messages, ramping to 1.0 on
    keyOn and to 0.0 on keyOff.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
(control parameters)
.keyOn - ( int , WRITE only ) - ramp to 1.0
.keyOff - ( int , WRITE only ) - ramp to 0.0
.target - ( float , READ/WRITE ) - ramp to arbitrary value.
.time - ( float , READ/WRITE ) - time to reach target (in seconds)
.duration - ( dur , READ/WRITE ) - duration to reach target
.rate - ( float , READ/WRITE ) - rate of change
.value - ( float , READ/WRITE ) - set immediate value
[ugen]: ADSR (STK Import)
STK ADSR envelope class.
see examples: adsr.ck
    This Envelope subclass implements a
    traditional ADSR (Attack, Decay,
    Sustain, Release) envelope.  It
    responds to simple keyOn and keyOff
    messages, keeping track of its state.
    The \e state = ADSR::DONE after the
    envelope value reaches 0.0 in the
    ADSR::RELEASE state.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
extends Envelope
(control parameters)
.keyOn - ( int , WRITE only ) - start the attack for non-zero values
.keyOff - ( int , WRITE only ) - start release for non-zero values
.attackTime - ( dur , READ/WRITE ) - attack time
.attackRate - ( float , READ/WRITE ) - attack rate
.decayTime - ( dur , READ/WRITE ) - decay time
.decayRate - ( float , READ/WRITE ) - decay rate
.sustainLevel - ( float , READ/WRITE ) - sustain level
.releaseTime - ( dur , READ/WRITE ) - release time
.releaseRate - ( float , READ/WRITE ) - release rate
.state - ( int , READ only ) - attack=0, decay=1 , sustain=2, release=3, done=4
.set - ( dur, dur, float, dur ) - set A, D, S, and R all at once
stk-reverbs
[ugen]: JCRev (STK Import)
John Chowning's reverberator class.
    This class is derived from the CLM JCRev
    function, which is based on the use of
    networks of simple allpass and comb delay
    filters.  This class implements three series
    allpass units, followed by four parallel comb
    filters, and two decorrelation delay lines in
    parallel at the output.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
(control parameters)
.mix - ( float , READ/WRITE ) - mix level
[ugen]: NRev (STK Import)
CCRMA's NRev reverberator class.
    This class is derived from the CLM NRev
    function, which is based on the use of
    networks of simple allpass and comb delay
    filters.  This particular arrangement consists
    of 6 comb filters in parallel, followed by 3
    allpass filters, a lowpass filter, and another
    allpass in series, followed by two allpass
    filters in parallel with corresponding right
    and left outputs.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
(control parameters)
.mix - ( float , READ/WRITE ) -
[ugen]: PRCRev (STK Import)
Perry's simple reverberator class.
    This class is based on some of the famous
    Stanford/CCRMA reverbs (NRev, KipRev), which
    were based on the Chowning/Moorer/Schroeder
    reverberators using networks of simple allpass
    and comb delay filters.  This class implements
    two series allpass units and two parallel comb
    filters.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
(control parameters)
.mix - ( float , READ/WRITE ) - mix level
stk - components
[ugen]: Chorus (STK Import)
STK chorus effect class.
    This class implements a chorus effect.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
(control parameters)
.modFreq - ( float , READ/WRITE ) - modulation frequency
.modDepth - ( float , READ/WRITE ) - modulation depth
.mix - ( float , READ/WRITE ) - effect mix
[ugen]: Modulate (STK Import)
STK periodic/random modulator.
    This class combines random and periodic
    modulations to give a nice, natural human
    modulation function.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
(control parameters)
.vibratoRate - ( float , READ/WRITE ) - set rate of vibrato
.vibratoGain - ( float , READ/WRITE ) - gain for vibrato
.randomGain - ( float , READ/WRITE ) - gain for random contribution
[ugen]: PitShift (STK Import)
STK simple pitch shifter effect class.
    This class implements a simple pitch shifter
    using delay lines.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
(control parameters)
.mix - ( float , READ/WRITE ) - effect dry/web mix level
.shift - ( float , READ/WRITE ) - degree of pitch shifting
[ugen]: SubNoise (STK Import)
STK sub-sampled noise generator.
    Generates a new random number every "rate" ticks
    using the C rand() function.  The quality of the
    rand() function varies from one OS to another.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
(control parameters)
.rate - ( int , READ/WRITE ) - subsampling rate
[ugen]: Blit (STK Import)
STK band-limited impulse train.
    This class generates a band-limited impulse train using a
    closed-form algorithm reported by Stilson and Smith in 
    "Alias-Free Digital Synthesis of Classic Analog Waveforms", 
    1996. The user can specify both the fundamental frequency 
    of the impulse train and the number of harmonics contained
    in the resulting signal.

    The signal is normalized so that the peak value is +/-1.0.

    If nHarmonics is 0, then the signal will contain all 
    harmonics up to half the sample rate. Note, however, 
    that this setting may produce aliasing in the signal 
    when the frequency is changing (no automatic modification 
    of the number of harmonics is performed by the 
    setFrequency() function).

    Original code by Robin Davies, 2005.
    Revisions by Gary Scavone for STK, 2005.
(control parameters)
.freq - ( float , READ/WRITE ) - base frequency (hz)
.harmonics - ( int , READ/WRITE ) - number of harmonics in pass band
.phase - ( float , READ/WRITE ) - phase of the the signal
[ugen]: BlitSaw (STK Import)
STK band-limited sawtooth wave.
    This class generates a band-limited sawtooth waveform
    using a closed-form algorithm reported by Stilson and
    Smith in "Alias-Free Digital Synthesis of Classic Analog
    Waveforms", 1996. The user can specify both the 
    fundamental frequency of the sawtooth and the number 
    of harmonics contained in the resulting signal.

    If nHarmonics is 0, then the signal will contain all 
    harmonics up to half the sample rate. Note, however,
    that this setting may produce aliasing in the signal
    when the frequency is changing (no automatic modification
    of the number of harmonics is performed by the setFrequency()
    function).

    Based on initial code of Robin Davies, 2005.
    Modified algorithm code by Gary Scavone, 2005.
(control parameters)
.freq - ( float , READ/WRITE ) - base frequency (hz)
.harmonics - ( int , READ/WRITE ) - number of harmonics in pass band
.phase - ( float , READ/WRITE ) - phase of the the signal
[ugen]: BlitSquare (STK Import)
STK band-limited square wave.
    This class generates a band-limited square wave signal.
    It is derived in part from the approach reported by 
    Stilson and Smith in "Alias-Free Digital Synthesis of
    Classic Analog Waveforms", 1996. The algorithm implemented
    in this class uses a SincM function with an even M value to
    achieve a bipolar bandlimited impulse train. This 
    signal is then integrated to achieve a square waveform.
    The integration process has an associated DC offset but that
    is subtracted off the output signal.

    The user can specify both the fundamental frequency of the
    waveform and the number of harmonics contained in the 
    resulting signal.

    If nHarmonics is 0, then the signal will contain all 
    harmonics up to half the sample rate. Note, however, that
    this setting may produce aliasing in the signal when the
    frequency is changing (no automatic modification of the
    number of harmonics is performed by the setFrequency() function).

    Based on initial code of Robin Davies, 2005.
    Modified algorithm code by Gary Scavone, 2005.
(control parameters)
.freq - ( float , READ/WRITE ) - base frequency (hz)
.harmonics - ( int , READ/WRITE ) - number of harmonics in pass band
.phase - ( float , READ/WRITE ) - phase of the the signal
stk - file i/o
[ugen]: WvIn (STK Import)
STK audio data input base class.
    This class provides input support for various
    audio file formats.  It also serves as a base
    class for "realtime" streaming subclasses.

    WvIn loads the contents of an audio file for
    subsequent output.  Linear interpolation is
    used for fractional "read rates".

    WvIn supports multi-channel data in interleaved
    format.  It is important to distinguish the
    tick() methods, which return samples produced
    by averaging across sample frames, from the 
    tickFrame() methods, which return pointers to
    multi-channel sample frames.  For single-channel
    data, these methods return equivalent values.

    Small files are completely read into local memory
    during instantiation.  Large files are read
    incrementally from disk.  The file size threshold
    and the increment size values are defined in
    WvIn.h.

    WvIn currently supports WAV, AIFF, SND (AU),
    MAT-file (Matlab), and STK RAW file formats.
    Signed integer (8-, 16-, and 32-bit) and floating-
    point (32- and 64-bit) data types are supported.
    Uncompressed data types are not supported.  If
    using MAT-files, data should be saved in an array
    with each data channel filling a matrix row.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
(control parameters)
.rate - ( float , READ/WRITE ) - playback rate
.path - ( string , READ/WRITE ) - specifies file to be played
[ugen]: WaveLoop (STK Import)
STK waveform oscillator class.
    This class inherits from WvIn and provides
    audio file looping functionality.

    WaveLoop supports multi-channel data in
    interleaved format.  It is important to
    distinguish the tick() methods, which return
    samples produced by averaging across sample
    frames, from the tickFrame() methods, which
    return pointers to multi-channel sample frames.
    For single-channel data, these methods return
    equivalent values.

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
extends WvIn
(control parameters)
.freq - ( float , READ/WRITE ) - set frequency of playback ( loops / second )
.addPhase - ( float , READ/WRITE ) - offset by phase
.addPhaseOffset - ( float , READ/WRITE ) - set phase offset
[ugen]: WvOut (STK Import)
STK audio data output base class.
    This class provides output support for various
    audio file formats.  It also serves as a base
    class for "realtime" streaming subclasses.

    WvOut writes samples to an audio file.  It
    supports multi-channel data in interleaved
    format.  It is important to distinguish the
    tick() methods, which output single samples
    to all channels in a sample frame, from the
    tickFrame() method, which takes a pointer
    to multi-channel sample frame data.

    WvOut currently supports WAV, AIFF, AIFC, SND
    (AU), MAT-file (Matlab), and STK RAW file
    formats.  Signed integer (8-, 16-, and 32-bit)
    and floating- point (32- and 64-bit) data types
    are supported.  STK RAW files use 16-bit
    integers by definition.  MAT-files will always
    be written as 64-bit floats.  If a data type
    specification does not match the specified file
    type, the data type will automatically be
    modified.  Uncompressed data types are not
    supported.

    Currently, WvOut is non-interpolating and the
    output rate is always Stk::sampleRate().

    by Perry R. Cook and Gary P. Scavone, 1995 - 2002.
(control parameters)
.matFilename - ( string , WRITE only ) - open matlab file for writing
.sndFilename - ( string , WRITE only ) - open snd file for writing
.wavFilename - ( string , WRITE only ) - open WAVE file for writing
.rawFilename - ( string , WRITE only ) - open raw file for writing
.aifFilename - ( string , WRITE only ) - open AIFF file for writing
.closeFile - ( string , WRITE only ) - close file properly

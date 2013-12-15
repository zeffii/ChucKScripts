#### string

```c
.tolower()  
.toupper()  
.trim()  
.ltrim()  
.rtrim()

.substring(int pos)  
.substring(int pos , int len)  
.replace(int pos, string str)
.replace(int pos, int len, string str) 

.find(int ch)  
.find(int ch, int pos)  
.find(string str)  
.find(string str, int pos)  

.rfind(string str) // find str in string, return index of last instance
.rfind(string str, int pos) // find str in string, return index of last instance at or before index pos
.rfind(int ch)  // find ch in string, return index of last instance
.rfind(int ch, int pos)   // find ch in string, return index of last instance at or before index pos

.charAt(int index) // return character of string at index
.setCharAt(int index, int ch) // set character of string at index to ch
.insert(int pos, string str) // insert str at pos
.erase(int pos, int len) // remove len characters from string, beginning at pos
```

#### Array

```c
.cap()
.clear()
<<  // adds items, usage:   some_array << new_item;
[]  // elementwise lookup

```

#### Std
```c
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
```

#### Math

```c
// seed, forces reproducible random  
.srandom(n) //  use n to set random seed

.random() // random int between 0, max int
.randomf() // random float between 0.0 and 1.0
.random2(a, b) // random int between a and b
.random2f(a, b) // random float between a and b
```

*Math utility functions*

```c
.floor(float) // round down to next integeral ( 2.3 becomes 2.0 )
.ceil(float) // round up to next integral  ( 2.3 becomes  3.0 )
.round(float) // regular rounding rules apply
.trunc() // round to largest integral val no greater than x
.fmod(float, float)  // float remainder of x / y
.min(float, float) // returns lowest value of the two inputs
.max(float, float) // returns highest value of the two inputs
.nextpow2(float) // (int) returns smallest int (power of 2 greater than input)
```


*Math trig and mathematical operations*

```c
.hypot(fx, fy)  // takes floats, returns euclidean distance of vector 
.pow(a, b)  // a^b, takes ints or floats.
.sqrt(x)
.exp(x)
.log(x) // natural log
.log2(x)  // log base 2
.log10(x) // base 10

// all of these return floats
.sin(x) // for parameter control, not for generating audio 
.cos(x)
.tan(x)
.asin(x)
.acos(x)
.atan2(x,y)
.sinh(x)
.cosh(x)
.tanh(x)
```

#### dac

```c
.left 
.right
.chan(0)
.chan(1)
.chan(n) // in case more than 2 channels available
```

```c
// Panning! 
SinOsc s => Pan2 p => dac;
1.0 => p.pan; // one side
-1.0 => p.pan; // other side

pi  // 3.141592...

// noise generator, doesn't produce a repeating waveform, use
// as SinOsc etc
Noise n;
```

#### RegEx

```c
//
//
//      A walk-through and demo of string formatting
//
//      Nov 2013. 
//
//      Perl-compatible syntax can also be used for patterns.
//      http://www.cs.tut.fi/~jkorpela/perl/regexp.html
 
 
RegEx r;    // make a regex object
 
/*
    - RegEx.replace(string pat, string repl, string str)
      Replace the first instance of pat in str with repl, returning the
      result. 
*/
<<< "Demo 1: RegEx.replace" >>>;
 
"this 34-56-23 will contain 345-243-345 rewrites" => string fill_str;
["line", "several"] @=> string repl[];
 
for(0 => int s; s<repl.cap(); s++){
    r.replace("([0-9]{2,3}-?){3}", repl[s], fill_str) => fill_str;
}
<<< fill_str >>> ;
 
 
/*
    - RegEx.replaceAll(string pat, string repl, string str)
      Replace all instances of pat in str with repl, returning the
      result. 
*/
<<< "Demo 2: RegEx.replaceAll" >>>;
 
"this %s is no greater than this %s" => string fill_str2;
r.replaceAll("%s", "20", fill_str2) => fill_str2;
 
<<< fill_str2 >>> ;
 
 
/*  
    - RegEx.match(string pattern, string str)
      Return true if match for pattern is found in str, false otherwise
 
      \d is not a recognized excape sequence
*/
 
<<< "Demo 3: RegEx.match" >>>;
 
"this is a short demo string 0x3000h a match" => string fill_str3;
if (r.match("0x[0-9]{4}h", fill_str3)){
    <<< "yes found a match 1" >>>;
}
// fails :(
// if (r.match("0x\d{4}h", fill_str3)){
//      <<< "yes found a match 2" >>>;
// }
 
 
/*
    - RegEx.match(string pattern, string str, string matches[])
      Same as above, but return the match and sub-patterns in matches
      matches[0] is the entire matched pattern, matches[1] is the first 
      sub-pattern (if any), and so on. 
*/ 
```


// Arrays MUST match in # of elements
// Array of string. An arbitrary scale (C Major).
[ "c", "d", "e", "f", "g", "a", "b" ] @=> string pitches[];

// Array of int. In MIDI terms, these are the numbers of
// semitones above the root for a major scale.
[ 0, 2, 4, 5, 7, 9, 11 ] @=> int semis[];

// This is the trick. semis.cap == len(semis[]) FOR THE
// INT ARRAY. It isn't possible to (easily) get the len of
// an associative array (without counting it out in a loop
// or some such). so we use the len of the semis int array.
// In essence, we're "layering" a second, associative,
// string indexed array "on top of" the existing int array.
for ( int i; i < semis.cap(); i++ ){
    semis[i] => semis[ pitches[i] ]; // semis[i] VALUE
                                     // is now assigned to
                                     // INDEX pitches[i] e.g.
                                     // semis[3] => semis["f"]
                                     // so, <<< semis["f"] >>>;
                                     // yields '5'.
}

// print 'em out
for ( int i; i < semis.cap(); i++ ){
    <<< "\"" + pitches[i] + "\" ==", semis[ pitches[i] ]  >>>;
}

<<< "Also, semis[\"f\"] ==", semis["f"] >>>;

1::second => now;

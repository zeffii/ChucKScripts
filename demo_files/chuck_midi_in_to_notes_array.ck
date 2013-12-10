// MidiIn min;
// MidiMsg msg;

// // open midi receiver, exit on fail
// if ( !min.open(0) ) me.exit(); 

// while( true )
// {
//     // wait on midi event
//     min => now;

//     // receive midimsg(s)
//     while( min.recv( msg ) )
//     {
//         // print content
//         <<< msg.data1, msg.data2, msg.data3 >>>;
//     }
// }

MidiIn min;
MidiMsg msg;

// open midi receiver, exit on fail
if ( !min.open(0) ) me.exit(); 

int notes[0];
while( true )
{
    // wait on midi event
    min => now;

    // receive midimsg(s)
    while( min.recv( msg ) )
    {
        // print content
        msg.data1 => int mode;
        msg.data2 => int note;
        msg.data3 => int volume;

        if (mode == 128) notes << note;
        //else { [] @=> notes; }
    }
    if (notes.cap() > 0) {
        repr_int_array(notes);
    }
    int a[0] @=> notes;
}

//  array
fun void repr_int_array(int arr[])
{
    arr.cap() => int num_items;
    chout <= "[";
    for(0 => int i; i<num_items; i++){
        if (i>0) chout <= ",";    
        chout <= arr[i];
    }
    chout <= "] @=> int notes[];";
    chout <= IO.newline();
}


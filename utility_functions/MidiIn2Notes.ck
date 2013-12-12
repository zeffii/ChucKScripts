MidiIn min;
MidiMsg msg;

// open midi receiver, exit on fail
if ( !min.open(0) ) me.exit(); 

int notes[0];
int ncount;
while( true )
{
    min => now;
    while( min.recv( msg ) )
    {
        msg.data1 => int mode; 
        //<<< mode >>>;
        msg.data2 => int note;
        msg.data3 => int volume;
        
        if (mode == 144) {
             chout <= note;
             chout <= ", ";
        }
    }

    chout <= IO.newline();    
    int a[0] @=> notes;
}

// Machine.add("utilities.ck");

/* 
    definitions

    fun void repr_int_array(int arr[]){}
    fun void repr_string_array(string arr[]){}
    
    fun int random_from(int arr[]){}
    fun int inArray(int token, int arr[]){}
    fun int indexOfClosest(int ival, int arr[]){}
    fun int to_note(string str){}
    fun int[] set_from(int arr[]){}
    fun int[] randomArray_from(int arr[], int length){}
    fun int[] range(int start, int end){}
    fun int[] narray(int start, int next, int up_to){}
    fun int[] expand_scale(int scale[], int start_stop[]){    
    fun int[][] stepify(string sequence_data[]){}
    
    fun float average(int arr[]){}
    
    fun string repr(int arr[]){}
    fun string repr(string arr[]){}
    fun string[] split(string arr, string token){}
    
    fun SndBuf load_sample(string wavname){}

    
    https://gist.github.com/anonymous/7206152
    
*/    



fun string[] split_str(string str, string token){

    string collect[0];
    int pos;
    int pos2;
    while( str.find(token) >0){
        str.find(token) => pos2;
        collect << str.substring(pos, pos2);
        str.substring(pos2+1) => str;
    }
    collect << str;
    return collect;
}


fun int random_from(int arr[]){
    return arr[Math.random2(0, arr.cap()-1)];
}

fun int[] randomArray_from(int arr[], int length){
    // return new array of capacity length chosing elements from arr
    int generated_arr[0];
    for(0 => int i; i<length; i++){
        generated_arr << random_from(arr); // append element
    }
    return generated_arr;
}

fun int[] range(int start, int end){
    // includes start and end
    int arr[0];
    for(start => int i; i<=end; i++) arr << i;
    return arr;
}

fun int[] narray(int start, int next, int up_to){
    // (start, end..up_to)  (inclusive)
    int arr[0];
    start => int cval;
    next - start => int jump;
    for(cval; cval<=up_to; jump +=> cval){
        arr << cval;
    }
    return arr;  // matey!
}

fun int[] expand_scale(int scale[], int start_stop[]){

    // assumes we start somewhere above 0
    start_stop[0] => int start;
    start_stop[1] => int end;

    int expand_array[0];
    -1 => int last;
    int current;
    for(start => int i; i < end; i++){
        for(0 => int n; n<scale.cap(); n++){
            // avoids doubles, if the incoming scale ends an 
            // octave above the first note
            scale[n] + (i*12) => current;
            if (!(current == last)){
                expand_array << current;
                current => last;
            }
        }
    }
    return expand_array;
}


fun string repr(int arr[]){
    /*
    this returns a string representation of an int array,
    useful for debug printing.
    */
    "[" + Std.itoa(arr[0]) => string s;
    for (1 => int i; i < arr.cap(); i++){
        "," + Std.itoa(arr[i]) +=> s;
    }
    return s + "]";
}

fun string repr(string arr[]){
    
    //this returns a string representation of a string array,
    //useful for debug printing.
    
    "[" + arr[0] => string s;
    for (1 => int i; i < arr.cap(); i++){
        "," + arr[i] +=> s;
    }
    return s + "]";
}

fun void repr_int_array(int arr[])
{
    arr.cap() => int num_items;
    chout <= "[";
    for(0 => int i; i<num_items; i++){
        if (i>0) chout <= ",";    
        chout <= arr[i];
    }
    chout <= "]";
    chout <= IO.newline();
}

fun void repr_string_array(string arr[])
{
    arr.cap() => int num_items;
    chout <= "[";
    for(0 => int i; i<num_items; i++){
        if (i>0) chout <= ",";    
        chout <= arr[i];
    }
    chout <= "]";
    chout <= IO.newline();
}

fun int inArray(int token, int arr[]){
    /*
    tests membership of an array
    */ 
    for(0 => int i; i<arr.cap(); i++){
        if (arr[i]==token) return 1;
    }
    return 0;
}

fun int to_note(string str){
    if (str == "...") return -1;
    if (str == "OFF") return -2;
    if (str == "===") return -3;
 
    // check if within supported range
    str.substring(2) => Std.atoi => int oct;
    if (oct < 0 || oct > 10) return -4;
 
    str.substring(0,2) => str;
 
    [   "C-","C#","D-","D#","E-","F-",
        "F#","G-","G#","A-","A#","B-"
    ] @=> string notes_list[];
    
    // note must be in this list, else return -3 at the end
    for (0 => int i; i < notes_list.cap(); i++){
        if (str == notes_list[i]){
            return (i + oct * 12);
        }
    }
    return -5; 
}

fun int[][] stepify(string sequence_data[]){
    /*
    this function converts a string array to an int array,
    it accepts fuzzy formatting:
    "1..1..1..1.." becomes [1,0,0,1,0,0,1,0,0,1,0,0]
    "1..1.   .1..1.." also becomes [1,0,0,1,0,0,1,0,0,1,0,0]
    */

    sequence_data.cap() => int parts;
    32 => int steps;  // hard code for now
    <<< parts, steps >>>;
    
    int data_store[parts][steps];
    for(0 => int i; i<sequence_data.cap(); i++){

        sequence_data[i] => string seq_string;
        int part_data[0];
        int trigger;
        //<<< seq_string >>>;
        for(0 => int j; j < seq_string.length(); j++){
            seq_string.substring(j,1) => string token; // crazy

            if (token == " ") continue;
            if (token == ".") 0 => trigger;
            else if (token == "1") 1 => trigger;

            part_data << trigger;
        }
        //<<< repr_int_array(part_data)>>>;
        part_data @=> data_store[i];
    }
    return data_store;
}

fun SndBuf load_sample(string wavname){

    // usage
    // load_sample("kick_02") @=> SndBuf kick => dac;
 
    // turn incoming wavname into   path/wavename.wav
    // return a reference to a new buffer object.
    SndBuf temp_buff;
    me.dir() + "/audio/" + wavname  + ".wav" => temp_buff.read;

    // set to end, and set gain, then return the object
    temp_buff.samples() => temp_buff.pos;   
    0.8 => temp_buff.gain;
    return temp_buff;
}

fun float average(int arr[]){
    int sum;
    arr.cap() => int num_items;
    for(0 => int i; i < num_items; i++){
        arr[i] +=> sum;
    }
    sum $ float => float fsum;
    num_items $ float => float fcap;
    return fsum / fcap;
}

fun int indexOfClosest(int ival, int arr[]){
    // will find the closest value to ival in arr
    // if there are multiple, it will return the first.
    Math.INT_MAX => int min_distance;
    0 => int diff;
    -1 => int idx_tracker;

    for(0 => int i; i<arr.cap(); i++)
    {
        Math.abs(arr[i] - ival) => diff;
        if (diff < min_distance) 
        { 
            diff => min_distance;
            i => idx_tracker;
        }
    }
    return idx_tracker;

}

fun int[] set_from(int arr[]){
    // no order guaranteed
    // requires  inArray() to be present.
    int new_arr[0];
    new_arr << arr[0];

    for(1 => int i; i<arr.cap(); i++){
        if (inArray(arr[i], new_arr) == 0){
            new_arr << arr[i];
        }
    }
    return new_arr;
}



use rand::prelude::*;
use std::env;
use std::str::FromStr;

fn main() {

    // Get number of digits to print
    let digits;
    let args: Vec<String> = env::args().collect();
    if args.len() == 1 { digits = 10; }
    else { digits = i64::from_str(&args[1]).unwrap(); }

    // Print digits
    for _ in 0..digits {
        print!("{}", random::<u8>() % 10);
    }

    print!("\n");

}

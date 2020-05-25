use std::env;
use std::fs::File;
use std::io::prelude::*;
use std::str::FromStr;

fn main() {

    // Get number of digits to print
    let digits;
    let args: Vec<String> = env::args().collect();
    if args.len() == 1 { digits = 10; }
    else { digits = i64::from_str(&args[1]).unwrap(); }

    // Read digits-many bytes from /dev/urandom

    let file = File::open("/dev/urandom").unwrap();
    let mut random_bytes = file.bytes();

    // Print a non-0 digit as first digit to insure the output number is within
    // 10^digits..10^(digits+1)
    loop {
        if let Some(Ok(b)) = random_bytes.next() {
            if b % 10 == 0 { continue; }
            else { print!("{}", b % 10); break; }
        }
    }

    // Print digits-1 further digits
    for _ in 1..digits {
        if let Some(Ok(b)) = random_bytes.next() {
            print!("{}", b % 10);
        }
    }

    print!("\n");

}

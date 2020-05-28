use std::io::{stdout, stdin, BufRead, Write};
use std::env;

use rand::thread_rng;
use rand::seq::SliceRandom;

fn main() {

    let args: Vec<String> = env::args().collect();
    let delim = if args.len() > 1 { b'\0' } else { b'\n' };

    let mut lines: Vec<Vec<u8>> =
        stdin()
        .lock()
        .split(delim)
        .map(|v| { v.expect("Failed to Read Line") })
        .collect();

    &mut lines.shuffle(&mut thread_rng());

    let out = stdout();
    for l in lines.iter() {
        out.lock().write(       l).expect("Failed to Write Line");
        out.lock().write(&[delim]).expect("Failed to Write Line");
    }

}

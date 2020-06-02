use std::io::{stdin, stdout, BufRead, Write};

fn escape(b: u8) -> Vec<u8> {
    let escapees = vec![b'|', b'&', b';', b'<', b'>', b'(', b')', b'$', b'`', b'\\', b'"', b'\'', b'*', b'?', b'[', b'#', b'~', b'=', b'%', b' ', b'\t', b'\n'];
    if let Some(_) = escapees.iter().find(|&&x| { b == x }) { vec![b'\\', b] } else { vec![b] }
}

fn escape_and_print(record: Vec<u8>, delim: u8) {
    record
        .into_iter()
        .for_each(|b| { stdout().lock().write(&escape(b)).unwrap(); });
    stdout().lock().write(&[delim]).unwrap();
}

fn main () {

    let args: Vec<String> = std::env::args().collect();

    /* Argument mode */

    if (args.len() == 2 && args[1] != "-0") || args.len() > 2 {

        args.iter()
            .skip(1)
            .for_each(|arg| { escape_and_print(arg.as_bytes().to_vec(), b' '); });

        return;
    }

    /* Std-in mode */

    let delim;
    if args.len() > 1 && args[1] == "-0" { delim = b'\0' } else { delim = b'\n' }

    stdin()
        .lock()
        .split(delim)
        .map(|line| { line.unwrap() })
        .for_each(|line| { escape_and_print(line, delim) });

}

#[macro_use] extern crate downcast;
extern crate termion;

#[macro_use]
mod prolog;

use prolog::ast::*;
use prolog::io::*;
use prolog::machine::*;

#[cfg(test)]
mod tests;

pub static LISTS: &str   = include_str!("./prolog/lib/lists.pl");
pub static CONTROL: &str = include_str!("./prolog/lib/control.pl");
pub static QUEUES: &str = include_str!("./prolog/lib/queues.pl");

fn parse_and_compile_line(wam: &mut Machine, buffer: &str)
{
    match parse_code(wam, buffer) {
        Ok(packet) => {
            let result = compile_packet(wam, packet);
            print(wam, result);
        },
        Err(s) => println!("{:?}", s)
    }
}

fn prolog_repl() {
    let mut wam = Machine::new();

    load_init_str_and_include(&mut wam, BUILTINS, "builtins");
//    load_init_str(&mut wam, LISTS);
//    load_init_str(&mut wam, CONTROL);
//    load_init_str(&mut wam, QUEUES);

    loop {
        print!("prolog> ");

        match read() {
            Input::Line(line) => parse_and_compile_line(&mut wam, line.as_str()),
            Input::Batch(batch) =>
                match compile_listing(&mut wam, batch.as_str()) {
                    EvalSession::Error(e) => println!("{}", e),
                    _ => {}
                },
            Input::Quit => break,
            Input::Clear => {
                wam.clear();
                continue;
            }
        };

        wam.reset();
    }
}

fn main() {
    prolog_repl();
}

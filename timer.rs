use std::env;
use std::str::FromStr;
use std::time::Duration;

fn main() {
	let args: Vec<String> = env::args().collect();
    let query = i32::from_str(&args[1]).unwrap_or(0);
    let sleep_duration = Duration::from_secs(60);
    for minutes_left in (0..query).rev() {
	std::thread::sleep(sleep_duration);
        println!("{}",minutes_left);
    }
}
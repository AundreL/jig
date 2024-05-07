/*
 * project-name: jig
 * author: aundre lattie
 */
use clap::Parser;

#[derive(Parser, Debug)]
#[command(author, version, about, long_about=None)]
struct Args {
    #[arg(short, long)]
    dotsync: bool,
}

//const DEFAULT_NVIM_CONFIG_LOCATION:&str = ".config/nvim/init.vim";

fn main() {
    let args = Args::parse();
    
    if args.dotsync == true{
        dotsync();
    }
}

fn dotsync(){
    println!("dotsync not implemented");
}

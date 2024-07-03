/*
 * project-name: jig
 * author: aundre lattie
 */
use clap::{Parser, Subcommand};

#[derive(Parser, Debug)]
#[command(author, version, about, long_about=None)]
struct Args {
    
    #[clap(subcommand)]
    command: Commands
}

#[derive(Debug, Subcommand)]
enum Commands{
    Dotsync{},
    Update{}
}

//const DEFAULT_NVIM_CONFIG_LOCATION:&str = ".config/nvim/init.vim";

fn main() {   
    
    let args = Args::parse();
    
    println!("{:?}", args);
   
    match args.command {
        Commands::Dotsync{} => {
            dotsync();
        }
        Commands::Update{} => {
            println!("update")
        }
    }
}

fn dotsync() ->i64 {
    panic!("dotsync not implemented");
}

#[cfg(test)]
mod tests{
    use super::*;

    #[test]
    #[should_panic]
    fn test_dotsync(){
        dotsync();
    }
}

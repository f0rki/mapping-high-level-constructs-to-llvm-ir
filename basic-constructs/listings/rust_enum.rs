enum Foo {
    ABool(bool),
    AInteger(i32),
    ADouble(f64),
}

fn main() {
    let x = Foo::AInteger(42);
    let y = Foo::ADouble(1337.0);
    let z = Foo::ABool(true);

    if let Foo::ABool(b) = x {
        println!("A boolean! {}", b)
    }
    if let Foo::ABool(b) = y {
        println!("A boolean! {}", b)
    }
    if let Foo::ABool(b) = z {
        println!("A boolean! {}", b)
    }
}

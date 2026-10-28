pub fn main() void {
    // A count of cups is a number. "two" is a word. The compiler
    // refuses to mix them, and this file exists so the guide can
    // show the refusal in the compiler's own words.
    const cups: u8 = "two";
    _ = cups;
}

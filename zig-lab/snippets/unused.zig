pub fn main() void {
    // Declared, given a value, and never used again. Zig treats
    // that as an error, not a warning.
    const cups: u8 = 2;
}

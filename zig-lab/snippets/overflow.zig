const std = @import("std");

pub fn main() void {
    // 200 + 100 does not fit in a u8, whose largest value is 255.
    // In a Debug build (the default) Zig checks this at run time
    // and stops the program with a panic instead of wrapping
    // silently around to 44.
    var a: u8 = 200;
    const b: u8 = 100;
    a += b;
    std.debug.print("total: {d}\n", .{a});
}

const std = @import("std");
pub fn main() void {
    const x = 1 + 2;
    std.debug.print("{d}\n", .{x});
}

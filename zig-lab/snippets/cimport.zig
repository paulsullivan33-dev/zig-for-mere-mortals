const std = @import("std");

// Pull C's standard I/O header into Zig. Everything declared in
// it becomes available under the name c.
const c = @cImport(@cInclude("stdio.h"));

pub fn main() void {
    _ = c.printf("printed by C's printf, called from Zig\n");
    const total = c.abs(-7);
    std.debug.print("abs(-7) according to C: {d}\n", .{total});
}

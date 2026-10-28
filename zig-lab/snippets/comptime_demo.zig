const std = @import("std");

// A factorial worked out while the compiler runs, not while the
// program runs. The table below is finished arithmetic before
// the program ever starts.
fn factorial(comptime n: u64) u64 {
    var result: u64 = 1;
    var i: u64 = 2;
    while (i <= n) : (i += 1) {
        result *= i;
    }
    return result;
}

const factorials = blk: {
    var table: [11]u64 = undefined;
    for (&table, 0..) |*slot, i| {
        slot.* = factorial(i);
    }
    break :blk table;
};

// A single value worked out at compile time the same way: this
// constant holds the finished answer before the program starts.
const twenty_factorial = factorial(20);

pub fn main() void {
    for (factorials, 0..) |value, i| {
        std.debug.print("{d}! = {d}\n", .{ i, value });
    }
    // The constant was finished at compile time too.
    std.debug.print("20! = {d}\n", .{twenty_factorial});
}

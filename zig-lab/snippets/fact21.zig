const std = @import("std");
fn factorial(comptime n: u64) u64 { var r: u64 = 1; var i: u64 = 2; while (i <= n) : (i += 1) { r *= i; } return r; }
const twenty_one = factorial(21);
pub fn main() void { std.debug.print("{d}\n", .{twenty_one}); }

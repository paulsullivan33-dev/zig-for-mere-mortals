const std = @import("std");

fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "adding two numbers" {
    try std.testing.expectEqual(@as(i32, 5), add(2, 3));
}

test "adding a negative number" {
    // This expectation is wrong on purpose. The guide shows this
    // test failing, so a reader can see what a failing test looks
    // like in Zig's own words. add(2, -3) is -1, not 10.
    try std.testing.expectEqual(@as(i32, 10), add(2, -3));
}

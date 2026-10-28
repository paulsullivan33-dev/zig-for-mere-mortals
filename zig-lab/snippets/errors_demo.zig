const std = @import("std");

// The things that can go wrong while pouring, named as a set.
const PourError = error{
    NotEnoughWater,
    TooHot,
};

// Returns either a number of millilitres poured or one of the
// errors above. The return type says so: PourError!u16.
fn pourCup(water_ml: u16, temp_c: u8) PourError!u16 {
    if (temp_c > 95) return error.TooHot;
    if (water_ml < 200) return error.NotEnoughWater;
    return 200; // one full cup
}

// Returns the position of a word, or null when it is not there.
// The ?usize return type is an optional: a value, or nothing.
fn findWord(words: []const []const u8, wanted: []const u8) ?usize {
    for (words, 0..) |word, i| {
        if (std.mem.eql(u8, word, wanted)) return i;
    }
    return null;
}

pub fn main() void {
    const shelf = [_][]const u8{ "kettle", "filter", "beans", "scale" };

    if (findWord(shelf[0..], "beans")) |index| {
        std.debug.print("found 'beans' at position {d}\n", .{index});
    }
    if (findWord(shelf[0..], "teapot")) |index| {
        std.debug.print("found 'teapot' at position {d}\n", .{index});
    } else {
        std.debug.print("'teapot' is not on the shelf\n", .{});
    }

    const first = pourCup(750, 80) catch |err| {
        std.debug.print("first pour failed: {s}\n", .{@errorName(err)});
        return;
    };
    std.debug.print("first pour: {d} ml\n", .{first});

    const second = pourCup(120, 80) catch |err| {
        std.debug.print("second pour failed: {s}\n", .{@errorName(err)});
        return;
    };
    std.debug.print("second pour: {d} ml\n", .{second});
}

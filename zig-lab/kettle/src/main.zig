const std = @import("std");

// The guide's own first program: it replaces the template's main
// wholesale. A plainer main, with no arguments and nothing
// returned, is legal Zig — the template's longer form is one
// option, not a requirement.
pub fn main() void {
    const kettle_ml: u16 = 750;
    const cup_ml: u16 = 250;
    const cups = kettle_ml / cup_ml;
    std.debug.print("a {d} ml kettle fills {d} cups of {d} ml\n", .{ kettle_ml, cups, cup_ml });
}

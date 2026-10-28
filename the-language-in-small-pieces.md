# The Language in Small Pieces

This chapter is the whole language at
walking pace: the pieces every later
chapter uses, each shown in code small
enough to check by eye. It is not the
complete language — chapter 14 is honest
about what a first guide leaves out —
but it is enough to read and write the
rest of this book, and enough to be
dangerous in the good way.

## Values and the names of types

Zig's number types carry their size in
their name. `u16` is an **unsigned**
integer — no negative values — of 16
bits, so it holds 0 to 65,535. `i32` is a
**signed** 32-bit integer. The pattern is
regular: `u8` (0 to 255), `i64`, `u128`,
and the floats `f32` and `f64`, whose
name counts their bits the same way.
There is no bare "int" whose size
depends on the machine and the decade;
when a size is genuinely "whatever the
machine prefers", Zig spells even that
honestly as `usize` and `isize`.

A value is introduced with `const` when
it will never change, and `var` when it
will:

```zig
const cup_ml: u16 = 250;   // fixed
var poured: u16 = 0;       // will change
poured += cup_ml;
```

Two manners matter. A `const` or `var`
with a type written out, as above, is
checked against that type — chapter 5
shows the compiler refusing a word where
a `u16` belongs. And anything declared
must be *used*: an unused `const` is a
compile error, not a warning that scrolls
past. Zig would rather stop the build
than let dead code accumulate quietly.
(The polite escape, when you truly mean
to ignore a value, is `_ = value;` — the
underscore is a named discard.)

## Functions

A function says what it takes and what
it gives back, in that order, and `pub`
makes it reachable from other files:

```zig
pub fn add(a: i32, b: i32) i32 {
    return a + b;
}
```

That is the `add` from the template's
library file, and it is complete. There
are no hidden inputs and no hidden
outputs: if a function can fail, its
return type says so (chapter 7); if it
needs memory, an allocator arrives as an
ordinary argument (chapter 1's rule).

## Text and printing

Text in quotes is a **string**, and Zig
treats it as a slice of bytes — the next
section's idea — rather than a special
creature. Printing uses the standard
library. `std.debug.print` writes to the
program's **standard error** stream, the
channel meant for messages to the human
rather than data for the next program,
which is why the guides and this lab use
it for learning: it needs no setup and
can never corrupt a data file the program
was supposed to produce.

```zig
std.debug.print("a {d} ml kettle\n", .{kettle_ml});
```

The `{d}` is a placeholder asking for a
decimal number; the `.{ ... }` after the
comma is the list of values to fill the
placeholders, in order. `{s}` fills with
text. Chapter 3's program fills three at
once. Production programs write their
real output through a writer, as the
template's library half did — the same
`print` idea, aimed at a file or the
standard output on purpose rather than
by default.

## Arrays and slices

An **array** is a fixed number of values
of one type, and its length is part of
its type:

```zig
const shelf = [_][]const u8{ "kettle", "filter", "beans", "scale" };
```

That is an array of four text values; the
`[_]` says "count them yourself,
compiler", and `[]const u8` is the type
of each piece of text: a **slice**. A
slice is the working form of "some of
these, in a row": a pointer to where they
start and a count of how many — text,
lists of function arguments, and chapter
7's word search all travel as slices. A
slice knows its own length (`shelf.len`
is 4), and indexing past the end of one
in a debug build is caught at run time —
chapter 10's safety net again.

## Doing things repeatedly, and choosing

The ordinary machinery, with nothing up
its sleeve:

```zig
for (shelf, 0..) |item, i| {
    std.debug.print("{d}: {s}\n", .{ i, item });
}

var n: u8 = 3;
while (n > 0) : (n -= 1) {
    std.debug.print("{d}...\n", .{n});
}

if (poured >= cup_ml) {
    std.debug.print("a full cup\n", .{});
} else {
    std.debug.print("not yet\n", .{});
}
```

Read the `for` line as the shelf pattern
this guide keeps using: *for each item
in the slice, with its position counted
from 0, do this*. The `|item, i|` part
names the two things each round provides.
The `while` carries its increment in the
`: (n -= 1)` tail, so the loop's whole
mechanism is visible on its first line —
no hidden third clause hiding at the end
of a long condition. An `if` gives a
value as happily as it guards a block:
`const label = if (full) "full" else
"part";` is ordinary Zig, and chapter 7
uses the same shape to unwrap values
that might not exist.

## Structs, in one paragraph

Related values travel together in a
**struct** — named fields, each with its
type — and chapter 7's example could have
been one: `const Cup = struct { ml: u16,
temp_c: u8 };`. Structs can carry
functions of their own, declared inside
them, which is how Zig does the work
other languages give to classes, without
inheritance and without anything hidden.
The standard library is full of them;
the template's writer is one. A first
guide needs the shape recognised, not
mastered: when you see `std.mem.Allocator`
or `std.ArrayList`, you are looking at a
struct's name and the namespace it lives
in, nothing more mystical.

Check: the kettle program in
`zig-lab/kettle/` uses every idea in this
chapter except the loop. Adding the
`for` loop over a shelf of drinks to its
`main`, and getting the four numbered
lines out of `zig build run`, is the
exercise this chapter leaves you — the
pieces are all above, and the compiler
will grade it instantly.

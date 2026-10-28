# Errors and Optionals

Programs meet two different kinds of
"not the happy outcome", and many
languages blur them into one vague
mechanism — a special value here, an
exception thrown from nowhere there.
Zig keeps them separate, names both in
the type system, and makes a program
deal with each before it may use the
result. An **error** means the operation
was attempted and failed: the water was
too hot, the file was not there. An
**optional** means there may simply be
nothing: the word was not on the shelf.
This chapter builds one small program
that pours coffee and searches a shelf,
and meets both kinds in Zig's own words.

## Error sets: naming what can go wrong

An error in Zig is a value from a named
set, declared like anything else:

```zig
const PourError = error{
    NotEnoughWater,
    TooHot,
};
```

A function that can pour or fail says so
in its return type. `PourError!u16`
reads as: *either one of those errors,
or a `u16`* — the `!` joins the error
set to the success type, and the joined
thing is called an **error union**.

```zig
fn pourCup(water_ml: u16, temp_c: u8) PourError!u16 {
    if (temp_c > 95) return error.TooHot;
    if (water_ml < 200) return error.NotEnoughWater;
    return 200; // one full cup
}
```

Returning an error is one line,
`return error.TooHot;`, and returning
success is an ordinary value. Nothing
is thrown and nothing unwinds in secret:
the failure travels back as the
function's result, in the open, exactly
as chapter 1's "no hidden control flow"
promised.

## Dealing with an error union

The caller may not use the `u16` until
the error half has been answered. Zig
offers three honest postures:

**Pass it up with `try`.** `const cup =
try pourCup(750, 80);` — if `pourCup`
failed, this function's own caller
receives the error immediately, and the
rest of the line never happens. The
caller's return type must include the
error, which is how failure stays
declared all the way up to `main`.

**Handle it here with `catch`.** The
lab's program handles both pours this
way:

```zig
const second = pourCup(120, 80) catch |err| {
    std.debug.print("second pour failed: {s}\n", .{@errorName(err)});
    return;
};
```

The `catch` names the error it caught
(`err`), and `@errorName` turns it back
into the text of its name for printing.
A `catch` can instead substitute a
default — `catch 0` — or insist that
failure is impossible with `catch
unreachable`, which a debug build will
check, loudly, if you turn out to be
wrong (chapter 10).

**Let the program end with it.** A
`main` declared `!void` — the template's
form, now decoded — may simply let an
error escape, and the runtime prints it
with a trace. Reasonable for tools,
rude for libraries.

## Optionals: the value that may not be

The shelf search returns the other kind
of not-quite:

```zig
fn findWord(words: []const []const u8, wanted: []const u8) ?usize {
    for (words, 0..) |word, i| {
        if (std.mem.eql(u8, word, wanted)) return i;
    }
    return null;
}
```

`?usize` is an **optional**: either a
`usize` or `null`. Comparing text uses
the standard library's `std.mem.eql`,
because slices are compared by their
contents, not their addresses. The
caller unwraps with the same `if` shape
chapter 4 met, or supplies a stand-in
with `orelse`:

```zig
if (findWord(shelf[0..], "beans")) |index| {
    std.debug.print("found 'beans' at position {d}\n", .{index});
}
```

Inside the block, `index` is a plain
number, unwrapped and safe. Outside it,
the value stays optional and the
compiler will not let it be used as a
number — the possibility of `null` must
be answered every time, which is the
entire point. "Not found" needs no
apology and no exception: searching a
shelf for a teapot that is not there is
not a failure of the search.

## The whole program, run

Both ideas together are the lab's
`zig-lab/snippets/errors_demo.zig`, and
its run exercises every branch — found,
not found, poured, and failed
(transcript `zig-lab/transcripts/t08-errors-and-optionals.txt`):

```text
$ zig run snippets/errors_demo.zig
found 'beans' at position 2
'teapot' is not on the shelf
first pour: 200 ml
second pour failed: NotEnoughWater
exit: 0
```

Note the last line's calm: the second
pour failed, the program *reported* it,
and the exit code is still 0, because
nothing went wrong with the program —
one of its operations failed, was named,
and was handled, which is the difference
this chapter exists to teach.

Check: change the second pour's call to
`pourCup(750, 99)` and re-run. The
report changes to `second pour failed:
TooHot` — the other member of the set —
and nothing else in the program needed
to change, because the set was declared
before either failure happened.

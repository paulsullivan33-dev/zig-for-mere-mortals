# Comptime — Work Done While Compiling

Every language draws a line between two
moments: **compile time**, when the
compiler reads the program, and **run
time**, when the finished program works.
Most languages let only a little happen
on the compiler's side of the line — a
constant folded here, a size computed
there. Zig moves the line. In Zig,
ordinary code — the same functions,
loops and conditions you have been
reading all along — can run *while the
compiler runs*, and whatever it produces
is simply part of the finished program.
The keyword is **comptime**, and it is
the idea the language is named for in
most people's minds after an hour with
it. This chapter computes a table of
factorials before the program starts,
and explains why that is not a party
trick.

## A table finished before the start

A **factorial** — written 5! — is 5 × 4
× 3 × 2 × 1 = 120, and factorials grow
embarrassingly fast. Programs that need
them usually compute them when asked.
Here they are computed when *compiled*.
From the lab's
`zig-lab/snippets/comptime_demo.zig`:

```zig
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
```

Two comptime mechanisms are at work.
The parameter is marked `comptime n`:
this function may only be called with a
value known while compiling, and its
body — an ordinary loop, no special
dialect — runs on the compiler's side
of the line. And the block labelled
`blk:` is a compile-time block: it
builds the table entry by entry and
hands the finished array out with
`break :blk table`. (The `undefined`
starting value is Zig being honest that
the array begins as uninitialised
memory; every slot is filled before the
break.) By the time `main` exists, the
table is a constant in the program. The
run has nothing left to compute
(transcript `zig-lab/transcripts/t07-comptime.txt`):

```text
$ zig run snippets/comptime_demo.zig
0! = 1
1! = 1
2! = 2
3! = 6
4! = 24
5! = 120
6! = 720
7! = 5040
8! = 40320
9! = 362880
10! = 3628800
20! = 2432902008176640000
```

The last line prints a second constant
from the same file, `twenty_factorial`,
defined the same way — as a constant,
so the compiler worked it out.
Note that 20! is near the top of what a
`u64` can hold, and the limit is enforced
on the compiler's side of the line too.
Ask for 21! in a constant — the lab did,
in `zig-lab/snippets/fact21.zig` — and
no program is ever produced
(transcript `zig-lab/transcripts/t16-comptime-overflow.txt`):

```text
error: overflow of integer type 'u64' with value '51090942171709440000'
note: called at comptime here
```

The exact value that did not fit,
printed in the error. Work done early
fails early too — and fails *informatively*,
before anything exists that could crash.

## Why this replaces so much machinery

Other languages reach for separate tools
to do what comptime does with the
language itself:

- **Macros and code generators** —
  programs that write programs, in a
  second dialect you must also learn.
  A comptime function is just a function,
  called at the other moment.
- **Templates and generics** — the
  machinery by which a list or a sort
  works for any type of value. In Zig, a
  function can take a *type itself* as a
  comptime parameter and return a new
  type built from it: `std.ArrayList(u8)`
  from the template is exactly that, a
  function call whose argument and
  result are types, evaluated while
  compiling. Types are values on the
  compiler's side of the line.
- **Configuration by constants** — table
  sizes, lookup tables, parsed data —
  computed once, checked by the compiler,
  and shipped as facts.

The discipline runs both ways: anything
marked `comptime` must be knowable at
compile time. Feed `factorial` a number
read from the command line and the
compiler refuses, because that number
does not exist yet on its side of the
line. Chapter 5 taught how to read such
refusals; this one will arrive in the
same shape, naming the value that was
not known soon enough.

## A measured word of caution

Comptime is not free speed sprayed over
everything. Work done at compile time
makes compiling slower — the demo's
table costs the compiler a few
microseconds and a beginner nothing, but
a project that computes megabytes of
tables pays for it on every build, and
the cache in chapter 2 is what makes
that bearable. The honest rule the
language encourages: compute at compile
time what is *known* at compile time and
reused at run time — tables, sizes,
types, checked constants — and let the
program do its own work when it runs.

Check: add a constant of your own —
`const twelve = factorial(12);` — print
it, and re-run with `zig run`. The
answer, 479001600, arrives — and if you
time the two runs, the *program's* speed
has not changed, because the arithmetic
happened in the build you already
watched, not in the running you are
timing. (The constant is what forces
the compiler's side of the line; the
same call in the middle of `main`, with
nothing asking for it early, is allowed
to wait for run time — comptime decides
what *may* be known, and constants are
where a program says what *must* be.)

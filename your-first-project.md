# Your First Project

A Zig program can be a single file, as
chapter 1's hello showed. A Zig *project*
— the thing you build, test and hand to
other people — is a folder with a
standard shape, and the toolchain will
write that shape for you. This chapter
runs `zig init`, reads every file it
creates without flinching, builds the
result, runs it, and then replaces the
template's program with a smaller one of
our own — the project the rest of the
guide keeps returning to. It is called
**kettle**, because the guide's examples
are about making coffee, and no name
deserves more thought than that.

## zig init

In an empty folder (the lab made one
called `kettle` and stepped into it):

```bash
zig init
```

```text
info: created build.zig
info: created build.zig.zon
info: created src/main.zig
info: created src/root.zig
info: see `zig build --help` for a menu of options
```

(transcript `zig-lab/transcripts/t01-init.txt`).
Four files. Two are programs, one is a
build script, one is a package
description. Nothing else: no hidden
folders of machinery, no configuration
in a format you have not met.

## The package description

`build.zig.zon` describes the project to
the toolchain. A `.zon` file is Zig
syntax used as a data file — the same
braces and dots as the language itself.
The fields that matter on day one:

```text
.name = .kettle,
.version = "0.0.0",
.fingerprint = 0xc116e03c2e3109a3,
.minimum_zig_version = "0.17.0",
.paths = .{
    "build.zig",
    "build.zig.zon",
    "src",
},
```

The **fingerprint** is an identity the
toolchain generates when the package is
created: together with the name it says
*this* kettle project, as opposed to any
other. Leave it alone — the file's own
comments explain, with unusual firmness,
why changing it is a hostile act when
the package is someone else's fork. The
rest of the file is mostly comments
explaining dependency fields you will
not need until a project imports another
package, and this guide's never does.

## The template's two programs

`src/root.zig` is the project's library
half: reusable code other programs could
import. The template puts two things in
it — a function that prints a message
through a **writer** (a destination for
text, handed in by the caller), and a
small adding function with a test
attached, which chapter 6 meets properly:

```zig
pub fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    try std.testing.expect(add(3, 7) == 10);
}
```

`src/main.zig` is the program half, and
in 0.17.0 it deserves an honest look,
because it is *not* the three-line hello
from chapter 1. The current template's
`main` takes an argument,
`init: std.process.Init`, and returns
`!void` — a type chapter 7 will decode as
"nothing, or an error". It uses that
`init` to reach the command-line
arguments and an object called an
**Io** — the standard library's new way
of doing input and output, in which a
program receives its connection to the
outside world instead of assuming one.
The template prints its greeting through
the standard library's debug print,
logs its arguments, and finishes by
calling the library half to write a
sentence to the real output.

Read it once, in the transcript or in
`zig-lab/snippets/template-main.zig`,
and take the right lesson: **the template
shows where the language is heading, and
it is more machinery than a first program
needs.** Nothing in it is compulsory.
The plain `main` of chapter 1 is legal,
and section five below swaps it in.

## Build it and run it

```bash
zig build
```

Nothing prints when it succeeds — Zig's
build is quiet on purpose, and chapter 6
finds the same manners in its test
runner. What it leaves behind is a
folder named `zig-out`, and in
`zig-out/bin`, the finished program:

```text
$ ls zig-out/bin
kettle

$ ./zig-out/bin/kettle
All your codebase are belong to us.
info: arg: ./zig-out/bin/kettle
Run `zig build test` to run the tests.
exit: 0
```

(transcript `zig-lab/transcripts/t02-build-and-run.txt`).
Three lines, three different voices: the
greeting is the template's debug print;
the `info:` line is its log of the
command line it received (you can watch
it change by adding arguments:
`./zig-out/bin/kettle one two`); and the
last line is the library half writing to
the program's real output. The first
build on a machine takes a while —
the standard library compiles too — and
later builds reuse the cache and finish
in a blink. `zig build run` does the two
steps at once, build then run, and is
the form the rest of the guide uses.

## Our own main

Here is the whole of the guide's
`src/main.zig`, which replaces the
template's file (the project in
`zig-lab/kettle/` already has it in
place):

```zig
const std = @import("std");

pub fn main() void {
    const kettle_ml: u16 = 750;
    const cup_ml: u16 = 250;
    const cups = kettle_ml / cup_ml;
    std.debug.print("a {d} ml kettle fills {d} cups of {d} ml\n", .{ kettle_ml, cups, cup_ml });
}
```

```text
$ zig build run   (in the kettle project)
a 750 ml kettle fills 3 cups of 250 ml
exit: 0
```

Five lines of body, and every piece of
chapter 4 is already in it: values whose
types are named (`u16`, a sixteen-bit
unsigned number), values that cannot
change (`const`), one whose type the
compiler works out for itself (`cups`),
and a print with placeholders. The build
script did not need editing to accept
the new main: `build.zig` only points at
the file, and chapter 9 reads how.

Check: `zig build run` in the project
prints the kettle line and exits 0. If
instead it prints the "belong to us"
greeting, you are running a stale build
in another folder — the likeliest first
confusion in any build system, and worth
meeting here, in a project with twelve
files, rather than later in one with
twelve thousand.

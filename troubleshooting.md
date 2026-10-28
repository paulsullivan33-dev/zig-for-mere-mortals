# Troubleshooting

The failures a Zig beginner actually
meets, in roughly the order they arrive,
each with the check that settles it.
Most are in this guide already, in the
chapters that earned them; this page is
the index of bruises, including the
ones this guide's own lab collected.

## "zig: command not found"

The shell cannot find the program, so
nothing else in this guide can start.
Either Zig is not installed, or its
folder is not on the shell's PATH.
Settle it with `zig version` in a fresh
terminal after following chapter 2's
install — including the part where the
PATH line goes into the shell's startup
file, because a PATH set in one terminal
dies with that terminal.

## The build succeeded, but it was not the build you asked for

Chapter 10's trap, and the one this
lab fell into hardest. A command can
exit 0 while ignoring what you meant:
`-Doptimize=ReleaseFast` on a direct
compile was accepted silently and built
Debug, because that spelling belongs to
`zig build`'s project options, while a
direct compile takes `-O ReleaseFast`.
The guard is behavioural: **verify the
artifact, not the command line.** Run
the program and check for the behaviour
the flag should have changed; check its
size; ask `file` what it is. A build
that did what you asked can prove it. A
build that did not, cannot hide from
those three questions for long.

## Nothing happened when I ran the tests

Something did: they passed. `zig build
test` and `zig build` are silent on
success and report through the exit
code, as chapter 6 explained. When you
need to *see* it, ask for the summary:
`zig build test --summary all` shows
each step, whether it ran or was
cached, and how long it took. If the
summary says `cached` and you expected
a fresh run, the code did not change
since the last one — which is itself a
finding worth having, usually about
which file you actually saved.

## The program I ran is not the program I edited

Stale output wears several disguises.
You are standing in a different folder
than the one you edited — check with
`pwd`, and remember chapter 3's warning.
You ran `zig-out/bin/kettle` after a
`zig build run` habit changed which copy
is fresh — rebuild, then run. Or, from
chapter 12, `zig-out` holds binaries
for more than one target side by side,
and the one you picked is the ARM build
from an hour ago. `file` settles which
is which, every time, and is cheaper
than the debugging that follows from
guessing.

## An error names a type I have never seen

Normal, and temporary. Zig's compiler
speaks in exact types — `*const [3:0]u8`
and its cousins — and chapter 5 is the
decoder: sizes and signs are in the
names, `*` is a pointer, `[]` is a
slice, `?` is an optional, `!` joins an
error set. When the stranger belongs to
the standard library, read its source:
it is on your disk, in the folder `zig
env` reported, written in the same Zig
you are learning. That is a genuine,
if unadvertised, feature of the
language: the library's code is not a
black box, it is next week's reading.

## A tutorial's code does not compile

Check the version before checking
yourself. `zig version` on your machine,
against the date or version the
tutorial names. Chapter 14's exhibits —
the removed `@cImport`, the redesigned
input/output in the current template —
mean whole categories of older material
now fail in ways that say nothing about
your competence. Prefer the official
documentation for your release, and
when an example fails, try to name
which of the two Zig versions involved
the error belongs to. It is a real
skill in a young language, and it
transfers: today's Zig will be someone
else's old tutorial soon enough.

## Everything is slow the first time

The first build on a machine compiles
the parts of the standard library you
use and fills the cache; the first
cross-compile does the same for a new
target. Later builds reuse both. A
first build measured in tens of seconds
on a small machine is the platform
being honest about work actually done,
not a fault — chapter 2's cache paths
show where the work is kept. Consistent
slowness on *repeat* builds is the real
symptom; its first suspect is a project
doing heavy comptime work, and chapter
8 named that bargain when you made it.

## The unused-variable error will not go away

It is not a warning, and it will not be
demoted to one: chapter 5. Use the
value, delete the declaration, or
discard it explicitly with `_ = value;`.
If the value arrived from a function
that can fail, the discard must answer
the error half too — `catch` it with a
decision, per chapter 7 — because
ignoring a possible failure silently is
exactly what the rule exists to prevent.

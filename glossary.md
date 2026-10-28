# Glossary

**ABI** — the convention by which a
compiled program talks to a system's
libraries; the third part of a target
triple (chapter 12).

**Allocator** — a program's supplier of
memory, passed explicitly to anything
that needs to allocate, so no allocation
is ever hidden (chapters 1, 4).

**Array** — a fixed number of values of
one type, with the count part of the
type (chapter 4).

**Build graph** — the set of steps a
`build.zig` script describes, with their
dependencies, for the build runner to
execute and cache (chapter 9).

**Cache** — the stored results of
earlier compilations, local to a project
(`.zig-cache`) and global to a machine,
that make repeat builds quick (chapters
2, 9).

**comptime** — Zig's keyword for work
done while the compiler runs: ordinary
code whose inputs must be known at
compile time, whose results become part
of the finished program (chapter 8).

**Cross-compiling** — building a program
for a different machine than the one
running the compiler (chapter 12).

**Debug** — the default optimisation
mode: modest speed, full runtime safety
checks (chapter 10).

**Error set** — a named collection of
errors a function may return, declared
with the `error{ ... }` syntax (chapter
7).

**Error union** — a type of the form
`ErrorSet!T`: either one of the errors,
or a value of type `T` (chapter 7).

**extern** — a declaration of something
that exists elsewhere — in C code, for
instance — whose definition the linker
will supply (chapter 11).

**Optional** — a type of the form `?T`:
either a value of type `T`, or `null`
(chapter 7).

**Panic** — a deliberate, reported crash:
the runtime safety net stopping a
program that was about to corrupt
itself, with the reason and the line
(chapter 10).

**ReleaseFast / ReleaseSafe /
ReleaseSmall** — the optimised modes:
fast with the safety checks off, fast
with them on, and small with them off
(chapter 10).

**Slice** — a pointer to the first of a
run of values plus their count, written
`[]T`; the form text, lists and buffers
travel in (chapter 4).

**Standard library** — the `std` box of
ready-made parts shipped with the
compiler, as readable Zig source on
your own disk (chapters 1, 2).

**Step** — a named piece of a build
graph that `zig build <name>` runs;
`run` and `test` are ordinary steps a
project defines (chapter 9).

**Target triple** — a machine named in
three parts: processor, operating
system, ABI — as in `aarch64-linux-gnu`
(chapter 12).

**try / catch** — the two ways to answer
an error union at a call site: pass the
error up to your own caller, or handle
it on the spot (chapter 7).

**Writer** — a destination for text —
a file, the terminal, a buffer — handed
to code that prints, so printing never
assumes where it is going (chapters 3,
4).

**zig cc** — the complete C compiler
(Clang, plus linking pieces and many
platforms' C libraries) bundled inside
the `zig` program (chapter 11).

**ZON** — Zig Object Notation: the
language's own syntax used as a data
format, as in `build.zig.zon` (chapter
3).

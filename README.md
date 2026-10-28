# Zig for Mere Mortals

Some programs have to live close to the
machine: an operating system, a game
engine, the software inside a small
device, a library that every other
language calls. For fifty years that work
belonged to **C**, a language that trusts
the programmer completely and checks
almost nothing. **Zig** is a newer
language built for the same territory,
with a different bargain: it stays small
enough to hold in your head, it hides
nothing the machine will do on your
behalf, and it checks a great deal — the
type of every value, the errors every
function can return, the arithmetic that
does not fit — where C would have shrugged
and carried on.

This guide explains how that works. It
starts a real project with `zig init`,
reads the template the toolchain writes,
builds and runs it, and then takes the
language apart in small pieces: values and
types, the compiler errors you will
actually meet, tests that pass quietly and
one that fails out loud, the two kinds of
"nothing went wrong" Zig keeps separate —
an **error** and an **optional** — and
**comptime**, Zig's way of running
ordinary code while the compiler works so
the finished program starts with the
answers already in it. Later chapters read
the build system (which is itself a Zig
program), the safety checks that come
free in a debug build and leave in a fast
one, the C compiler bundled into the same
tool, and cross-compiling — building a
program for a machine you do not own,
from the one on your desk.

The lab behind this guide ran the real
thing: **Zig 0.17.0**, the official
release tarball from ziglang.org, checksum
verified, on a small Linux machine. It
created a project, built and ran it,
replaced the template's program with a
smaller one of its own, ran the tests,
and made the mistakes on purpose so the
guide can show them honestly: a test with
a wrong expectation, a word assigned where
a number belongs, a variable declared and
never used, an addition that overflows.
It computed a table of factorials at
compile time, poured make-believe cups of
coffee through functions that can fail in
named ways, compiled a C program with
`zig cc`, and built the same Zig program
for an ARM processor and for Windows,
proving each result by asking the `file`
tool what it was holding.

What the lab could not do, it did not
fake. It had one Linux machine, so
installing on Windows and macOS is
described from the project's
documentation, and so is the path for
calling big existing C libraries, where
the lab verified the first step — turning
a C header into Zig declarations — and
says plainly where its evidence ends. One
thing the lab expected to demonstrate is
gone from this version of Zig entirely,
and chapter 11 names it rather than
pretending otherwise: the `@cImport`
builtin that older tutorials teach no
longer exists in 0.17.0. `criteria.md`
keeps the full ledger of what was run and
what was only read.

## What this guide covers

- [**What Zig is**](what-zig-is.md) —
  the mental model: C's territory with
  the checking turned on, nothing hidden,
  and one toolchain that compiles, builds,
  tests and cross-compiles
- [**Installing Zig**](installing-zig.md) —
  one tarball, a checksum worth checking,
  and a compiler that is a single program
  you can carry anywhere
- [**Your first project**](your-first-project.md) —
  `zig init` and the four files it writes,
  the template read honestly, and the
  first build and run
- [**The language in small pieces**](the-language-in-small-pieces.md) —
  values, types with their sizes in their
  names, constants and variables,
  functions, arrays and slices, and a
  small program of our own
- [**Reading compile errors**](reading-compile-errors.md) —
  the compiler's own words for a type
  mismatch and an unused variable, and
  how to read the file, line, caret and
  reference trace it hands you
- [**Testing**](testing.md) — tests that
  live in the same file as the code, the
  silence of a passing run, and one
  failing test read line by line
- [**Errors and optionals**](errors-and-optionals.md) —
  error sets, `try` and `catch`, and the
  difference between "it failed" and
  "there wasn't one"
- [**Comptime**](comptime.md) — code that
  runs while the compiler runs, a table
  of factorials finished before the
  program starts, and types treated as
  values
- [**The build system**](the-build-system.md) —
  `build.zig` read in pieces: modules,
  steps, the run and test steps you
  already used, and where the output lands
- [**Safety and optimisation modes**](safety-and-optimisation.md) —
  the overflow that stops a debug build
  cold and sails through a fast one, and
  the flag spelling that decides which
  build you actually got
- [**Zig cc and the C connection**](zig-cc-and-c.md) —
  a real C compiler inside the Zig tool,
  a C program compiled and run, headers
  translated to Zig, and the builtin
  that is not there any more
- [**Cross-compiling**](cross-compiling.md) —
  one machine, three programs: the same
  source built for this computer, for an
  ARM board, and for Windows, each proven
  with `file`
- [**Formatting and small tools**](formatting-and-small-tools.md) —
  `zig fmt`, the one true layout, and a
  check mode that fails a messy file
- [**Limits**](limits.md) — a language
  that has not reached 1.0 yet, tutorials
  that age in months, a small standard
  library still being rearranged, and
  the honest rest
- [**Troubleshooting**](troubleshooting.md) —
  the build that was not the build you
  asked for, the test run that said
  nothing, the tutorial that describes a
  different Zig, and the traps this
  guide's lab fell into so you don't
  have to
- [**Glossary**](glossary.md) — the
  terms, collected in one place

## What it doesn't cover

Zig for embedded work — bootloaders,
kernels, bare metal with no operating
system underneath — is a large country
this guide only points at from the
cross-compiling chapter. Replacing a
build system across a whole company,
writing Zig libraries for other languages
to consume, and the package ecosystem's
manners are pointed at too, not taught.
This guide stays with one person, one
machine, and programs small enough to
check by eye, which is where the language
is best learned anyway.

## How to use this guide

Read chapter 1 for the model, then
install in chapter 2 and start the
project in chapter 3 in the same sitting:
the language chapters that follow all
refer back to that project. Chapters 5
and 6 — reading errors, and testing —
are worth reading before you need them,
which will be soon. Chapter 8,
**comptime**, is the idea that makes Zig
feel different from every language it
competes with; do not skip it even if
the factorial table looks like a party
trick. The lab's project lives in
`zig-lab/kettle/`, its small one-purpose
programs in `zig-lab/snippets/`, and its
transcripts in `zig-lab/transcripts/`.

---

## Part of the series

This guide is one of the [For Mere Mortals](https://paulsullivan33-dev.github.io/mere-mortals/) guides: plain-language guides to the tools programmers and makers use.

Related guides:

- [C for Mere Mortals](https://paulsullivan33-dev.github.io/c-for-mere-mortals/)
- [Rust for Mere Mortals](https://paulsullivan33-dev.github.io/rust-for-mere-mortals/)
- [Make for Mere Mortals](https://paulsullivan33-dev.github.io/make-for-mere-mortals/)

## License

The writing in this guide is licensed under [CC BY 4.0](https://github.com/paulsullivan33-dev/zig-for-mere-mortals/blob/main/LICENSE). Code examples and lab scripts are licensed under the [MIT License](https://github.com/paulsullivan33-dev/zig-for-mere-mortals/blob/main/LICENSE-CODE).

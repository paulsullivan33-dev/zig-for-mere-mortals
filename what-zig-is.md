# What Zig Is

Every program eventually talks to the
machine: memory, files, the network card,
the screen. Most modern languages stand
between you and that conversation with a
manager of their own — a runtime that
allocates memory for you, collects it when
you are done, and decides a great deal
behind your back. A few languages hand you
the conversation directly. The famous one
is **C**, from 1972: tiny, fast, everywhere,
and famously willing to let a program
damage itself without a word of complaint.

**Zig is a language for that same direct
work, written with fifty years of hindsight.**
It compiles to native machine code, manages
no memory on your behalf, and has no
runtime watching over the program. What it
adds to C's bargain is checking. In Zig the
size of every number type is in its name,
a function declares the errors it can
return as part of its type, arithmetic that
overflows is caught in a normal build, and
a value that might not exist is marked as
such and cannot be used until you have
dealt with the possibility. The checks are
not a manager. They are the compiler
refusing to build a program whose own
statements contradict each other.

## The rule the language keeps repeating

One principle explains most of Zig's
choices, and the project's own
documentation states it plainly: **only one
obvious way to do things, and nothing
hidden.** Concretely:

- **No hidden control flow.** If a line of
  code calls a function, it looks like a
  function call. Nothing quietly runs extra
  code — no secret conversions, no operators
  that secretly call functions of their own.
- **No hidden memory allocation.** If a part
  of a program needs memory, the code says
  where the memory comes from, passing an
  **allocator** — the program's memory
  supplier — to anything that needs one.
  The standard library never reaches for
  memory behind your back.
- **No macros and no separate preprocessor.**
  The tricks other languages do with text
  substitution, Zig does with ordinary code
  that runs at compile time — chapter 8's
  subject, and the language's signature idea.

The result is a language small enough that
its whole grammar fits in a short document,
aimed at programs that must be *robust*
(surviving bad input and bad luck),
*optimal* (fast and small when you say so),
and *clear* (readable by the next person,
who is often you).

## One tool, several trades

Zig arrives as a single program called
`zig`, and it does more than compile Zig:

- `zig build` runs a project's build
  script — itself a Zig program (chapter 9).
- `zig test` builds and runs the tests
  written inside the source files
  (chapter 6).
- `zig fmt` formats source code the one
  agreed way (chapter 13).
- `zig cc` is a complete C compiler,
  bundled in (chapter 11).
- Any of these can aim at a different
  machine than the one you are sitting at —
  a different processor, a different
  operating system — with one flag
  (chapter 12).

That bundling is why people who never
write a line of Zig still install it: as a
pocket C compiler and cross-compiler it is
remarkably convenient, and chapter 11 is
honest about that being a legitimate reason
to be here.

## A first taste

After installing (chapter 2), a complete
program is three lines, and `zig run`
compiles and runs it in one step. From the
lab's transcript `zig-lab/transcripts/t04-first-programs.txt`:

```bash
zig run hello.zig
```

```zig
const std = @import("std");

pub fn main() void {
    std.debug.print("hello, world\n", .{});
}
```

```text
hello, world
```

Two details in those three lines will keep
coming back. `@import("std")` brings in the
**standard library** — Zig's box of
ready-made parts — and `std.debug.print`
prints text, with the `{d}`-style
placeholders and the `.{...}` list of
values to fill them that chapter 4 uses
throughout. And `main` is declared `pub`,
public: the starting point of the program
has to say it can be reached from outside.

## Who it is for

The programmer maintaining something
written in C who wants the same control
with fewer ways to shoot their own foot.
The systems student who wants to see what
a compiler actually promises and checks.
The embedded or game or tools programmer
who needs small, fast, dependency-free
binaries for machines they do not own.
And the curious: Zig is young enough that
one person can still learn essentially all
of it, which stopped being true of most
languages decades ago.

## What it is not

Zig is not finished. The version this guide
ran is **0.17.0**, and the project has not
yet made the 1.0 promise that the language
will stop changing underneath you — chapter
14 shows two places where this very guide's
lab ran into the ground having moved. It is
not a managed language: no garbage
collector will tidy your memory, and
chapter 7's honesty about errors is matched
by an equal honesty about lifetimes being
your problem. It is not the fastest route
to a web service or a phone app; other
languages carry far more ready-made web
machinery, and Zig's own standard library
is deliberately small. And it is not a
safer C by magic — the checks are real, but
they are the checks of a compiler, not a
supervisor, and the fast build in chapter
10 turns several of them off on purpose.

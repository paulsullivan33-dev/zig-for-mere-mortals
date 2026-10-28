# Reading Compile Errors

Sooner or later — usually in the first
hour — the compiler refuses. In Zig that
refusal is not an obstacle between you
and the work; it *is* the work, a good
part of it. The compiler has read your
program more carefully than you have, and
its complaint, read properly, names the
file, the line, the exact characters, and
the contradiction it found. This chapter
makes two mistakes on purpose and reads
both refusals word by word, so the third
one — yours — is already familiar.

## A word where a number belongs

The file is kept in the lab as
`zig-lab/snippets/type_error.zig`, and
its whole body is chapter 4's lesson
applied wrongly on purpose:

```zig
pub fn main() void {
    const cups: u8 = "two";
    _ = cups;
}
```

The declaration asks for a `u8`, a
number from 0 to 255. The value offered
is `"two"`, a piece of text. Compile it
directly — `zig build-exe` builds one
file into a program, no project needed:

```text
$ zig build-exe snippets/type_error.zig
snippets/type_error.zig:5:22: error: expected type 'u8', found '*const [3:0]u8'
    const cups: u8 = "two";
                     ^~~~~
exit: 1
```

(transcript `zig-lab/transcripts/t06-compile-error.txt`).
Read it the way the compiler wrote it:

- **`snippets/type_error.zig:5:22`** —
  the file, line 5, column 22. The error
  has an address.
- **`error: expected type 'u8', found
  '*const [3:0]u8'`** — the contradiction
  stated in one sentence: what the
  declaration demanded, and what it got.
  The second type is worth decoding once:
  a string in Zig is a pointer (`*`) to
  an array of 3 characters (`[3:0]`, the
  `0` noting it ends with a zero byte,
  the way C likes its text), each a `u8`.
  All of that was already in chapter 4;
  the compiler simply speaks it fluently
  and expects you to catch up.
- **The source line with the caret
  underline** — `^~~~~` stretches under
  exactly the value that offends. When
  the line is long, that underline is the
  fastest way to find the spot.

The transcript contains more after the
underline: a short **reference trace**,
naming where the offending code was
reached from (here, the standard
library's startup code calling `main`),
ending with a note that some references
were hidden and how to ask for them
(`-freference-trace=5`). For an error in
code called from many places, that trace
is the difference between "this line is
wrong" and "this line is wrong *when
reached this way*". For a first program,
the first three parts carry the message.

Exit code 1, and no program was made.
Zig does not produce a best-effort
binary from a contradictory source, and
it does not press on to print forty more
errors downstream of the first — it
stops, which keeps the list short enough
to actually read.

## Declared and never used

The second mistake is quieter:

```zig
pub fn main() void {
    const cups: u8 = 2;
}
```

```text
$ zig build-exe snippets/unused.zig
snippets/unused.zig:4:11: error: unused local constant
    const cups: u8 = 2;
          ^~~~
exit: 1
```

A value was declared, given a value, and
never used again, and Zig treats that as
an error — not a warning, not a style
note. The reasoning is the language's
usual one: dead declarations are almost
always the remains of a thought the
programmer did not finish, and the
cheapest moment to hear about it is now.
Two honest ways out: use the value, or
say out loud that you are discarding it
with `_ = cups;` — which is exactly what
the first example above does, and why it
got far enough to be caught by the type
check instead of this one. The same rule
applies to `var`, to function parameters,
and to values caught from functions that
can fail — chapter 7's `catch` blocks
exist partly because an error value may
not be silently ignored either.

## The general skill

Every Zig error message follows the
shape these two taught: address first,
contradiction in one sentence, the
offending text underlined, then traces
if the path matters. When a message
uses a type you do not recognise, decode
it as chapter 4 taught — sizes and
signs in the names, slices and pointers
spelled out — and when it names a
standard-library type, remember the
library is on your disk as readable
source, at the path `zig env` reported
in chapter 2. The compiler is not being
cryptic for sport. It is being exact,
and exactness read slowly is nearly
always enough.

Check: change `"two"` to the number it
means, recompile, and the command exits
0 and leaves a program behind. Then
change it to `300` — a number, but too
big for a `u8` — and meet a third
refusal, in the same shape, before
chapter 10 explains exactly what range
checking costs and when it is switched
off.

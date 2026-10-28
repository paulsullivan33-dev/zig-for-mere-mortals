# Safety and Optimisation Modes

A compiler can build the same program
several ways, trading checking for
speed. Zig offers four **optimisation
modes**, and the choice matters more
than in most languages, because the
modes decide whether a set of **runtime
safety checks** — arithmetic overflow,
indexing past the end of a slice, a few
other ways a program can quietly corrupt
itself — are watching while the program
runs. This chapter watches the same
eight-line program in two modes, and
then tells the story of the flag that
nearly fooled this guide's own lab,
because it is the most useful mistake
in the book.

## The four modes

- **Debug** — the default. Little
  optimisation, full safety checks, the
  fastest compiles. This is the mode to
  develop in.
- **ReleaseSafe** — optimised, and the
  safety checks stay on. Speed costs a
  little; the net stays up.
- **ReleaseFast** — optimised, safety
  checks off. The program trusts the
  code completely.
- **ReleaseSmall** — optimised for size,
  safety checks off, for programs that
  must fit somewhere small.

## The overflow, twice

The lab's `zig-lab/snippets/overflow.zig`
adds 100 to a `u8` already holding 200.
A `u8` tops out at 255; the true answer,
300, does not fit. In a Debug build:

```text
$ zig run snippets/overflow.zig
thread 71041 panic: integer overflow
/home/.../snippets/overflow.zig:10:7: 0x11e3bc5 in main (overflow.zig)
    a += b;
      ^
... (the trace continues through the standard library's start code)
exit: 134
```

(transcript `zig-lab/transcripts/t09-overflow.txt`).
The program is **stopped** — a **panic**,
Zig's word for a deliberate crash with a
report: the reason (`integer overflow`),
the exact line, underlined, and a trace
of how it got there. Exit code 134 is
the operating system reporting that the
program aborted. Nothing was written
over anything else's memory; no silent
wrong answer travelled onward. That is
the safety check earning its keep: the
bug is identical in both modes — only
the discovery differs.

Built the fast way, the same source
produces this (transcript
`zig-lab/transcripts/t12-releasefast-overflow.txt`):

```text
$ ./overflow_fast2
total: 44
exit: 0
```

300 does not fit in eight bits, so the
excess wraps: 300 − 256 = **44**, a
wrong answer delivered with total
confidence and a success code. This is
not a Zig defect — it is the documented
bargain of ReleaseFast, and C's ordinary
behaviour every day — but it is why the
mode is chosen on purpose, at the end,
rather than lived in by default. When
overflow is a real possibility and
wrapping is wrong but stopping is too
much, the standard library also offers
explicit arithmetic — functions that
return an optional or an error on
overflow — so the *code* states its
policy instead of the build flag
deciding in secret.

## The flag that nearly fooled the lab

Now the trap, from the lab's own first
attempt. Optimisation is spelled
**`-Doptimize=ReleaseFast`** for the
build system — `zig build
-Doptimize=ReleaseFast` — because that
is a *project option* the script in
chapter 9 offered. For a direct compile
— `zig build-exe`, `zig run`, `zig
test` — the spelling is different:
**`-O ReleaseFast`**. The lab reached
for the familiar one:

```text
$ zig build-exe snippets/overflow.zig -Doptimize=ReleaseFast -femit-bin=overflow_wrongflag
exit: 0
$ ./overflow_wrongflag
thread 71689 panic: integer overflow
    a += b;
      ^
exit: 134
```

No error, no warning — and no ReleaseFast.
The command compiled successfully, at
the default Debug settings, and the
resulting binary was byte-for-byte the
Debug size, 10,462,008 bytes against
the real ReleaseFast build's 4,037,832.
The `-D` spelling defined a build option
nobody in that command was consulting,
and Zig, following its own rule that an
option means what its consumer says it
means, accepted it silently.

Three lessons, in the order the lab
learned them. **The two spellings belong
to two different commands** — `-D` for
options a *project's* script defines,
`-O` for a direct compile's own
settings. **A successful exit code
proves the build succeeded, not that it
was the build you asked for** — the
verification was the *behaviour* (the
panic that should have been absent) and
the size, either of which exposed it in
seconds. And **verify the artifact, not
the command line**: chapter 12's habit
of asking `file` what a binary is turns
out to be a general habit, not a
cross-compiling one.

Check: build the overflow program with
`-O ReleaseSafe` and run it. It should
panic like Debug — optimised code, net
still up — and that makes three of the
four modes you have now held in your
hand, with only their sizes and speeds
left to differ.

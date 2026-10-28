# Zig cc and the C Connection

Inside the same `zig` program you have
been using all along there is a complete
C compiler. `zig cc` accepts the flags a
C programmer expects, produces ordinary
native programs, and — because it comes
from Zig — can aim at other machines as
easily as chapter 12 shows Zig itself
doing. This chapter compiles and runs a
real C program with it, explains why the
bundled compiler matters even to people
who never write Zig, and then follows
the connection in the other direction:
using C code from a Zig program, where
this version of Zig has moved the path,
and the lab can prove it.

## A C program, compiled by zig cc

The lab's whole C program is eight
lines, kept at `zig-lab/snippets/hello.c`:

```c
#include <stdio.h>

int main(void) {
    printf("hello from C, compiled by zig cc\n");
    return 0;
}
```

```text
$ zig cc --version (first line)
clang version 22.1.8

$ zig cc snippets/hello.c -o hello_c
exit: 0

$ ./hello_c
hello from C, compiled by zig cc
exit: 0

$ file hello_c
hello_c: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked, ...
```

(transcript `zig-lab/transcripts/t10-zig-cc.txt`).
The version line gives the game away:
under the name `zig cc` stands
**Clang**, the widely used C compiler
front end, at version 22.1.8 in this
release, together with the pieces needed
to link a finished program — including,
unusually, the standard C libraries for
many platforms, shipped inside the one
download. That is the trick that makes
the next chapter so easy: a C compiler
that already carries other machines'
libraries does not need each target
installed separately, which is the
weekend of package hunting that
cross-compiling usually begins with.

Two honest consequences follow. The
binary above is **dynamically linked**
to this machine's C library — it runs
here, and would need that library on
another machine — because the lab asked
for nothing else; `zig cc` takes the
usual flags for changing that, and the
cross-compiled binaries in chapter 12
came out statically linked by their own
route. And `zig c++` stands beside
`zig cc` in the same tool for C++ code —
named here as documented, since the
lab's C was deliberately small.

## Calling C from Zig: the moved path

The classic route from Zig into C was a
builtin, `@cImport`, which translated a
C header into Zig declarations inline,
in the middle of your program. Older
tutorials — including many a search
engine will hand you first — teach it as
*the* way. The lab wrote the canonical
example against chapter 7's shelf, and
Zig 0.17.0 answered (transcript
`zig-lab/transcripts/t14-cimport.txt`):

```text
$ zig run snippets/cimport.zig
snippets/cimport.zig:5:11: error: invalid builtin function: '@cImport'
const c = @cImport(@cInclude("stdio.h"));
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
exit: 1
```

`@cImport` is **gone** — removed from
the language, not deprecated with a
warning, gone. This is the honest price
of a pre-1.0 language, and chapter 14
counts it properly. What replaced it is
the same translation, done as a step
instead of a spell: `zig translate-c`
turns a header into a Zig file of
declarations, and the build system can
run that step for you and hand the
result to your program as a module. The
lab verified the step on a header of
its own, `zig-lab/snippets/triple.h`,
which promises one function
(transcript `zig-lab/transcripts/t15-translate-c.txt`):

```text
$ zig translate-c snippets/triple.h > triple.zig
exit: 0 (output is several hundred lines, mostly predefined macro constants)

$ grep -n "triple" triple.zig
4:pub extern fn triple(x: c_int) c_int;
```

There is the contract, translated:
`triple` exists elsewhere (the `extern`),
takes C's `int` under its Zig name
`c_int`, and returns one. Wiring that
module into a project and calling real
library code through it is where this
guide's evidence ends — the lab's C
library call is documented-only from
here, described from the project's
documentation, and chapter 11's reader
should treat large-library adventures
accordingly. The direction Zig is
taking is legible, though: translation
as a build step produces a file you can
read, keep, and diff, instead of a
builtin whose work happened invisibly
inside a compile — the language's
"nothing hidden" rule, applied to its
own machinery.

Check: `zig cc` any small C program you
have — a hello-world is enough — and
compare `file`'s verdict on its output
with the same program built by your
system's usual C compiler, if you have
one. Same species of program, two
compilers; the Zig download quietly
replaced a toolchain.

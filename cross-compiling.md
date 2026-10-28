# Cross-Compiling

**Cross-compiling** means building a
program for a machine other than the
one running the compiler: an ARM program
from an Intel laptop, a Windows program
from a Linux server. It is normally the
point where a project acquires a second
toolchain, a pile of foreign libraries,
and a long weekend. In Zig it is one
flag, because the compiler carries what
it needs — chapter 11's bundled C
libraries are half of that story, and
Zig code needs no C library unless it
asks for one. This chapter builds the
kettle program for two machines the lab
does not own, and proves each result the
only way available from here: by asking
the finished binary what it is.

## The target, in three parts

A machine is named by a **target
triple** — really three choices written
together: the processor family, the
operating system, and the **ABI**, the
convention for how programs talk to that
system's libraries. The two this chapter
uses:

- `aarch64-linux-gnu` — 64-bit ARM (the
  processor family in a Raspberry Pi 4
  or 5 and most modern single-board
  computers), Linux, the GNU C library
  convention.
- `x86_64-windows-gnu` — the same
  processor family as the lab's machine,
  Windows, the GNU-flavoured Windows
  convention.

The default, when no target is named,
is **native**: whatever machine is
doing the building. Chapter 9 showed
where the choice comes from — the
template's build script offered it as a
standard option — so spending it is one
flag on the build you already know.

## Two builds, two proofs

Both runs are in transcript
`zig-lab/transcripts/t11-cross-compile.txt`,
from inside the kettle project:

```text
$ zig build -Dtarget=aarch64-linux-gnu
exit: 0

$ file zig-out/bin/kettle
zig-out/bin/kettle: ELF 64-bit LSB executable, ARM aarch64, version 1 (SYSV), statically linked, with debug_info, not stripped
```

The build is silent, as builds are, and
the install step put the ARM program in
the same `zig-out/bin` the native build
used — a fact worth knowing before you
run the wrong one. Then the second:

```text
$ zig build -Dtarget=x86_64-windows-gnu
exit: 0

$ ls zig-out/bin
kettle
kettle.exe
kettle.pdb

$ file zig-out/bin/kettle.exe
zig-out/bin/kettle.exe: PE32+ executable (console) x86-64, for MS Windows, 7 sections
```

`file` — a standard Unix tool whose only
job is identifying what a file actually
is — confirms both: an ARM Linux
**ELF** executable, statically linked
(it carries everything it needs, the
sensible default for a program headed
to a small board), and a Windows **PE32+**
executable, arriving with its `.pdb`
debugging companion. The previous ARM
binary was overwritten in place by the
Windows build's install step — `kettle`
in that listing is now... the listing
deserves a careful read: the Windows
build installed `kettle.exe`, and the
extensionless `kettle` beside it is the
ARM build from the step before, left
untouched. `zig-out` is a shelf, not a
label; chapter 15's advice to verify
the artifact before shipping it anywhere
starts here.

Two limits, stated before enthusiasm
outruns them. The lab could not *run*
either program — there is no ARM machine
and no Windows machine in it — so
"builds for the target, proven by
`file`" is the claim, no more. And
programs that lean on a particular
system's libraries or behaviour will
meet those systems' rules when they get
there; cross-compiling removes the
toolchain problem, not the porting one.

## Why this matters beyond Zig

That one-flag experience is the reason
`zig cc` (chapter 11) has been adopted
by projects written entirely in C: the
same `-target` spelling works there,
turning a machine with one download
into a compiler for dozens of targets.
A list of everything this Zig knows how
to aim at is available from the tool
itself — `zig targets` prints it as
structured data — and it runs to
hundreds of combinations. The honest
beginner needs three: native, the board
on the shelf, and the operating system
most of the world insists on. You have
built all three.

Check: rebuild for your own machine with
plain `zig build`, and `file` the
result. It should report the native
format again — ELF, x86-64 on the lab's
machine — proving the target really was
a choice made per build, not a state
the project fell into.

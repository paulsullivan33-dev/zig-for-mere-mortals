# Limits

Every guide in this series ends its
teaching with the edges, and Zig's edges
are dominated by one fact that should be
stated as plainly here as the project
states it: **Zig has not reached version
1.0.** The release this guide ran is
0.17.0. Until 1.0, the project reserves
the right to change the language, the
standard library and the tooling in ways
that break existing code — and it uses
that right. This chapter collects what
that means in practice, most of it
demonstrated by this guide's own lab,
plus the limits that would remain true
even at 1.0.

## The ground moves — two exhibits from this lab

**Exhibit one: the vanished builtin.**
Chapter 11 wrote the most-taught Zig
idiom of the last several years,
`@cImport`, and the compiler answered
`invalid builtin function`. Not a
warning, not a deprecation cycle the
lab could lean on: in 0.17.0 it is gone,
and every tutorial, answer and book
chapter written against the older
versions now contains a small trap. The
replacement (translate-c as a step) is
arguably better engineering. It is
still a replacement.

**Exhibit two: the template that
changed its mind.** Chapter 3's
`zig init` in 0.17.0 writes a `main`
with a signature — `pub fn main(init:
std.process.Init) !void` — and an
input/output design, `std.Io`, that did
not exist in the form older guides
describe. The standard library's way of
doing input and output is being rebuilt
in the open, release by release. Code
written against the previous design
still compiles in many cases, but a
reader following a two-year-old walkthrough
will meet error messages about types
that walkthrough never mentions.

The practical conclusion is not "wait
for 1.0" — people ship real software in
Zig today, pinning a version and
upgrading deliberately. It is: **know
which version a source of information
describes before trusting it**, prefer
the documentation matching your
`zig version`, and treat the upgrade of
a real project as a task with a budget,
not an afternoon's afterthought.

## The library is small, on purpose and in progress

Zig's standard library covers the
essentials — memory, files, processes,
networking basics, data structures,
cryptography pieces — and stops there
with intent: no web framework, no
database drivers, no kitchen sink. What
a bigger language ships built in, a Zig
project assembles from packages, and
the package ecosystem is young: smaller
than C's or Rust's by an order of
magnitude, with quality varying exactly
as much as that suggests. Some of what
the library does have is itself mid-
rearrangement — the input/output
redesign above being the current
example — so even first-party code has
moving floors in places.

## Safety is a default, not a guarantee

Chapter 10's checks are real, and they
are also a setting. ReleaseFast removes
them by design; every mode leaves whole
categories of error to the programmer —
memory used after it is freed, two
parts of a program racing on the same
data, lifetimes reasoned about wrongly.
Zig gives sharper tools for these than C
does — allocators that detect leaks in
tests, slices that know their length —
but it does not make the category go
away. A program in Zig can be wrong in
ways a managed language would have
forbidden, and the honest sentence is
that Zig's bet is *detection and
clarity*, not *impossibility*.

## Smaller print

- **Compile times.** A first build
  compiles the standard library pieces
  you use, and large comptime work
  (chapter 8) is paid for at build time.
  The cache makes iteration quick; a
  cold build of a big project on a small
  machine is a coffee, not a blink.
- **Error messages can be deep.** The
  reference traces of chapter 5 are
  helpful and, for generic code gone
  wrong, occasionally very long. The
  information is there; the reading
  takes practice.
- **Tooling is younger than the
  language.** Editor support, debuggers
  and profilers work, but the polish a
  decades-old ecosystem takes for
  granted is still arriving.
- **One maintainer-shaped project.**
  Zig is developed by a small core team
  under a nonprofit foundation. That has
  produced unusual coherence — and
  means the roadmap moves at that
  team's pace, nobody else's.

None of this is a reason to avoid the
language for learning, for tools, for
the C-adjacent work it was built for —
the work this guide did. It is a reason
to choose it with your eyes open, pin
your version, and keep the project's
own release notes closer than any
tutorial. Including, in time, this one.

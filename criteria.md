# Writing criteria for this guide

Every "for Mere Mortals" guide is written to the same nine-point
standard, so a reader who trusts one can trust the rest. Here it
is, with the verification notes for this particular guide below.

1. **Fix it first.** Reader outcomes lead, not action items: each
   chapter opens by naming the outcome it delivers, shows a check
   the reader can run to confirm they got it, and a reasonable
   reader finishes able to state what was done, what it means,
   and what to try next.
2. **Plain language.** Short sentences, everyday vocabulary,
   technical terms defined on first use. No slang, and no
   idioms that only make sense in one country — the reader may
   be translating as they go.
3. **No dead ends.** A guide never tells the reader to do
   something it cannot show them how to verify. Every claim a
   reader relies on — an install, a command, an output — is
   something this guide demonstrates or clearly labels
   documented-only below.
4. **Live-verified where it matters.** Procedures are run for
   real in the guide's lab wherever the build machine allows it,
   and the transcripts kept in the repository are the evidence.
   What could not be run is listed honestly below, never
   presented as if it had been.
5. **General audiences.** Nothing in this guide — examples,
   fixtures, names, addresses — is modelled on any particular
   reader or author's real life, network, or organisations.
   The lab's examples are about making coffee, nothing more.
6. **Standalone.** A reader needs this guide, its lab, and
   nothing else. Where another guide would genuinely help, it
   is pointed to once, by name, and the chapter still completes
   without it.
7. **Honest about limits.** Chapter 14 names what the tool
   cannot do: a language that has not reached 1.0, builtins
   that vanish between releases, a small and partly
   mid-rearrangement standard library, safety checks that are
   a setting rather than a guarantee, and compile times paid
   in full on a small machine.
8. **The version is in the text, early.** The README and
   chapter 2 state the exact release the lab ran — Zig
   0.17.0 — before any procedure depends on it, because in a
   pre-1.0 language the version is part of every claim the
   guide makes, and chapter 14 shows two claims it falsified.
9. **Builds clean.** The site builds with MkDocs in strict mode
   with no warnings, and a fresh reader following the chapters
   in order reaches the stated outcome of each.

## Verification notes for this guide

The build machine is a 2-CPU, 7.7 GB Ubuntu sandbox. Zig
**0.17.0** was installed from the official release tarball
(`zig-x86_64-linux-0.17.0.tar.xz`, fetched from
ziglang.org/download) after its SHA-256 checksum matched the
value published on the download page. The lab project is
`zig-lab/kettle/`; the one-purpose programs are
`zig-lab/snippets/`; all transcripts are
`zig-lab/transcripts/`.

Run for real, with transcripts as evidence:

- Install and version: checksum comparison, `zig version`,
  `zig env` fields, on x86_64 (t00).
- `zig init` and the four files it creates, including the
  current template's `std.process.Init` main and its
  `build.zig.zon` fingerprint (t01).
- Building and running the untouched template: the three
  lines of output from its three voices (t02), and its
  tests — silent on success, the step tree and `cached`
  steps under `--summary all` (t03).
- The guide's own replacement `main` built and run through
  `zig build run`, and a three-line program run directly
  with `zig run` (t04).
- A test that fails, on purpose and labelled as such in its
  own file: `expected 10, found -1`, the FAIL line, the
  trace to the test's own line, the summary count, exit
  code 1 (t05).
- Three compile errors in the compiler's own words: a text
  value in a `u8` declaration, an unused local constant,
  and 300 in a `u8` (t06).
- Comptime: a factorial table built in a comptime block and
  20! folded at compile time (t07); and 21! asked for in a
  constant, refused at compile time with the exact value
  named (t16).
- Error sets and optionals in one running program: both
  `catch` branches, a found and a not-found search (t08).
- A runtime integer overflow panicking in a Debug build,
  with trace and exit code 134 (t09).
- `zig cc` (reporting itself as Clang 22.1.8) compiling and
  the lab running a C program, its output identified by
  `file` (t10).
- Cross-compiling the project to `aarch64-linux-gnu` and
  `x86_64-windows-gnu`, each product identified by `file`
  as an ARM ELF executable and a Windows PE32+ executable
  respectively (t11).
- The optimisation flag trap, fallen into and then proven:
  `-Doptimize=ReleaseFast` on a direct compile was accepted
  silently and produced a Debug-sized binary that still
  panicked; `-O ReleaseFast` produced a binary 4,037,832
  bytes against the Debug build's 10,462,008, and the
  overflow wrapped silently to 44 (t12).
- `zig fmt --check` failing a deliberately messy file with
  exit 1, and `zig fmt` rewriting it to canonical form
  (t13).
- The removal of `@cImport`, demonstrated by the canonical
  example failing with `error: invalid builtin function:
  '@cImport'` (t14), and its replacement's first step,
  `zig translate-c` turning the lab's own header into
  `pub extern fn triple(x: c_int) c_int;` (t15).

Documented only — described from the project's documentation,
not run, and the text does not claim otherwise:

- Installing on Windows and macOS, including the package
  manager routes (the lab had one Linux machine).
- Running the cross-compiled binaries: no ARM or Windows
  machine was available, so chapter 12 claims only that the
  builds succeed and `file` identifies their products.
- Calling a real C library from Zig through the translated
  module — the translation step is verified (t15); the
  wiring into a project build is described.
- `zig c++`, named once in chapter 11; the lab's C was kept
  deliberately small.
- The fuzz test the template carries: its existence is in
  the template source (t01); it was not fuzzed.
- The neighbours in chapter 1 and the ecosystem comparisons
  in chapter 14 are characterised, not benchmarked.

Fixtures are this guide's own and deliberately generic: a
project named for a kettle that fills cups of coffee, a
four-word shelf, and an addition that overflows because
200 + 100 does not fit in a byte. No example is modelled on
any real person, project, service or organisation.

# Formatting and Small Tools

One command ends every argument about
how Zig code should be laid out. `zig
fmt` rewrites source files into the
language's one canonical layout — the
indentation, spacing and line breaks
every Zig programmer's editor produces —
so a project's style is never a matter
of taste, review comments, or a
configuration file with four hundred
options. This short chapter runs it on
a file that needs it, and then collects
the small commands the earlier chapters
left scattered.

## The formatter, on a real mess

The lab wrote this file badly on
purpose (`zig-lab/snippets/badly_formatted.zig`,
before):

```zig
const std = @import("std");
pub fn main() void {
      const x    =    1+2;
        std.debug.print( "{d}\n" , .{x} );
}
```

The check mode names what it would
change and fails, which is what a
continuous-integration job wants
(transcript `zig-lab/transcripts/t13-fmt.txt`):

```text
$ zig fmt --check snippets/badly_formatted.zig
snippets/badly_formatted.zig
exit: 1
```

And the fix is the same command without
the flag — it rewrites the file in place
and names what it touched:

```text
$ zig fmt snippets/badly_formatted.zig
snippets/badly_formatted.zig
exit: 0

$ cat snippets/badly_formatted.zig
const std = @import("std");
pub fn main() void {
    const x = 1 + 2;
    std.debug.print("{d}\n", .{x});
}
```

Four-space indentation, spaces around
the `+`, no souvenirs of the argument.
Two practical notes. The formatter only
rearranges layout — it does not rename,
reorder, or repair, so a file that
formats cleanly can still fail chapter
5's checks. And it formats *any* valid
Zig, including `build.zig` and `.zon`
files, which is why every file this
guide has shown you already agrees in
style: the template came out of the same
machine.

## The small commands, collected

Each of these earned its place in an
earlier chapter; here they are on one
page, as the reference a working project
actually needs.

- `zig version` — the version, and the
  first thing to check when a tutorial
  disagrees with your machine (chapters
  2, 14).
- `zig env` — where the program, its
  library and its caches live.
- `zig init` — start a project (chapter
  3).
- `zig run file.zig` — compile and run
  one file, for experiments (chapter 1).
- `zig build-exe file.zig` — compile one
  file into a program you keep (chapter
  5).
- `zig test file.zig` — run one file's
  tests (chapter 6).
- `zig build`, `zig build run`,
  `zig build test` — the project's own
  steps, whatever the project's script
  defined (chapter 9).
- `zig build --help` — that project's
  menu of steps and options.
- `zig cc`, `zig c++` — the bundled C
  and C++ compilers (chapter 11).
- `zig translate-c` — a C header,
  turned into Zig declarations (chapter
  11).
- `zig targets` — every target this
  compiler can aim at, as data (chapter
  12).
- `zig fmt` — the one true layout,
  above.

One more worth knowing exists, and no
more than that in a first guide: `zig
ast-check` reads a file and reports its
errors without building anything, which
is how editors underline your mistakes
as you type. Your editor almost
certainly talks to it already.

Check: run `zig fmt --check` across the
kettle project — `zig fmt --check .` in
its folder. Every file should pass
unnamed and silent, exit 0, because the
template was born formatted and chapter
3's replacement `main` was written to
match. The first time it names one of
your files instead, you will have met
the working end of the one-style rule.

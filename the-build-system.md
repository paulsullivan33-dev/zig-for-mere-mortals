# The Build System

Most build tools are a second program to
learn, with a configuration language of
its own that nobody would choose for any
other purpose. Zig's build system makes
a different bet: the build script,
`build.zig`, is an ordinary Zig program,
run by the compiler, describing a **build
graph** — a set of steps and the order
they depend on — which the toolchain
then carries out, in parallel where it
can, and from its cache where nothing
changed. You have been using it since
chapter 3. This chapter reads the
template's script until the commands you
know — `zig build`, `zig build run`,
`zig build test` — are visibly just
names of steps the script defined.

## The shape of every build.zig

The whole file is one function:

```zig
pub fn build(b: *std.Build) void {
    // ...describe steps...
}
```

The toolchain calls it with `b`, a
**builder**: the object whose methods
declare what can be built and how the
pieces depend on each other. The
template's own header comment makes the
subtle point clearly: this function does
not perform the build. It *describes*
it. The running happens afterwards, by
the build runner, from the description —
which is why steps can be cached,
skipped, and run side by side.

## Targets and optimisation arrive as questions

Near the top, the template asks the
person building two standard questions:

```zig
const target = b.standardTargetOptions(.{});
const optimize = b.standardOptimizeOption(.{});
```

These lines do not choose a target or an
optimisation mode. They *offer the
choice on the command line*:
`-Dtarget=...` and `-Doptimize=...`
become available because the script
asked, and chapters 10 and 12 spend
them. Every option a script defines —
these two or its own — is listed by
`zig build --help` in that project, so
the menu of any project is one command
away and never needs memorising.

## Modules and the executable

The middle of the script builds the two
halves chapter 3 met. A **module** is a
root source file plus the settings that
go with it — the unit other code imports:

```zig
const mod = b.addModule("kettle", .{
    .root_source_file = b.path("src/root.zig"),
    .target = target,
});
```

`addModule` publishes the module under
the name `"kettle"`, which is the name
`@import("kettle")` in `main.zig` refers
to. The executable is then declared with
its own module, rooted at `src/main.zig`,
told the chosen target and optimisation,
and given the library module as an
import. One line finishes the default
behaviour:

```zig
b.installArtifact(exe);
```

That is why plain `zig build` leaves the
program in **`zig-out/bin`**: the
install step — copying finished
artifacts into `zig-out`, the install
prefix — is the default step, and this
line enrolled the executable in it.

## Steps: run and test are just names

A **step** is a named piece of the graph
that `zig build <name>` runs. The
template defines the two you know:

```zig
const run_step = b.step("run", "Run the app");
const run_cmd = b.addRunArtifact(exe);
run_step.dependOn(&run_cmd.step);
```

So `zig build run` means: find the step
called `run`, do what it depends on —
build the executable, install it, then
run the installed copy. The `test` step
is built the same way from *two* test
programs, one per module, depending on
both — which is precisely the pair
chapter 6's `--summary all` showed in
its tree. Nothing about `run` or `test`
is built into the toolchain; delete the
lines and the commands vanish, rename
them and the commands follow. Most real
projects grow steps of their own the
same way: a `check` step, a `docs` step,
a step that cross-compiles the release
set from chapter 12 in one go.

## The cache, briefly

Two caches make iteration quick: a
project-local `.zig-cache` and the
global one `zig env` named in chapter 2.
Between them, a rebuild that changes
one file recompiles that file and
relinks, and a rebuild that changes
nothing reports its steps as `cached` —
the summary in chapter 6 showed compile
steps reused wholesale. If a build ever
behaves as though your edit did not
exist, a stale cache is a suspect, but
a rare one; chapter 15 puts it in its
proper place, last on the list, after
the folder you are standing in and the
file you actually saved.

Check: run `zig build --help` in the
kettle project. The menu lists the
steps (`run`, `test`, install, uninstall)
and the options (`-Dtarget`,
`-Doptimize`, and friends) that this
one script created — the whole surface
of the build system for this project,
on one screen, because the script is
the surface.

# Installing Zig

Zig is distributed the way system tools
used to be: one folder containing one
program and its library, downloaded as a
single archive from the project's own
site. There is no installer to run, no
account to create, and nothing is added
to your system beyond the folder you put
it in. Deleting the folder uninstalls it
completely. This chapter does the Linux
install the lab performed; the Windows
and macOS routes are described at the end
and labelled, because the lab had one
machine and it was neither.

## The download

The project's download page is
[ziglang.org/download](https://ziglang.org/download/).
It lists the current release — **0.17.0**
when the lab visited — and, below it,
development builds. Take the release
unless you enjoy surprises: the chapters
ahead are already full of a young
language's changes without volunteering
for nightly ones.

Pick the archive for your machine. The
names read as *processor-operating
system*: the lab, on an ordinary 64-bit
Intel/AMD Linux machine, took
`zig-x86_64-linux-0.17.0.tar.xz`, a 57 MB
download. An ARM Linux machine wants the
`aarch64-linux` one, a Mac an entry with
`macos` in the name, and so on.

## Check the checksum

The download page publishes a **checksum**
for each archive: a short fingerprint
computed from the file's contents, which
changes completely if even one byte of
the file changes. Comparing the
fingerprint of what you downloaded against
the one the project published proves the
file arrived whole and is the file the
project released. It takes ten seconds:

```bash
sha256sum zig-x86_64-linux-0.17.0.tar.xz
```

The lab's answer matched the site's
published value exactly:

```text
1cbe9df9f27e6b78d14ccbca43b6703a404ef79ef1c463de901d7f088d4e2026
```

If yours does not match, download again;
do not shrug and continue. This is the
one step of the install that protects
every step after it.

## Unpack and put it on the path

```bash
tar -xf zig-x86_64-linux-0.17.0.tar.xz
```

That makes one folder,
`zig-x86_64-linux-0.17.0`, containing the
`zig` program and a `lib` folder — the
standard library, kept as readable Zig
source you can open and learn from, which
this guide does more than once. Move the
folder somewhere permanent (the lab left
its own in a work folder; `/opt` or your
home directory are both fine), then make
the program findable by adding its folder
to your shell's **PATH** — the list of
folders the shell searches when you type
a command name:

```bash
export PATH=$HOME/zig-x86_64-linux-0.17.0:$PATH
```

That line lasts for the current terminal.
Adding it to your shell's startup file
(`~/.bashrc` for the bash shell) makes it
permanent; do that once the version check
below has passed.

## The version check

```bash
zig version
```

```text
0.17.0
```

(lab transcript `zig-lab/transcripts/t00-version.txt`).
A longer report is `zig env`, which lists
where the program lives, where its
library is, and where it keeps its
**cache** — compiled pieces it reuses so
later builds are quick:

```text
$ zig env (first fields)
.{
    .zig_exe = "/home/.../zig-x86_64-linux-0.17.0/zig",
    .lib_dir = "/home/.../zig-x86_64-linux-0.17.0/lib",
    .std_dir = "/home/.../zig-x86_64-linux-0.17.0/lib/std",
    .global_cache_dir = "/home/.../.cache/zig",
    .version = "0.17.0",
```

Check: `zig version` answers with the
version you downloaded, from a fresh
terminal, without you pointing at the
folder. Until it does, later chapters'
commands will fail for the boring reason
that the shell cannot find the program,
so it is worth getting this right now.

## Windows and macOS — documented only

The lab did not run these; they are the
project's documented routes, stated so a
reader on those systems can start, and
the rest of the guide works the same once
`zig version` answers.

On **Windows**, the archive is a `.zip`
with the same shape inside — one `zig.exe`
and the `lib` folder — and the usual
route is to unpack it somewhere permanent
and add that folder to the PATH in the
system's environment-variable settings.
Windows package managers (`winget`,
Scoop, Chocolatey) also carry Zig.

On **macOS**, the archive is a `.tar.xz`
as on Linux and the route is identical:
unpack, PATH, check. The Homebrew package
manager carries it too, as `brew install
zig` — with the standing warning about
package managers everywhere, that their
version may trail the project's own
releases, and `zig version` is the
arbiter of what you actually got.

# Testing

A **test** in Zig is a small block of
code that sits in the same file as the
code it checks, states what should be
true, and is run by one command. There
is no separate test folder convention to
learn, no framework to install, and no
configuration file: the `test` keyword
is part of the language, and `zig build
test` (or `zig test` for a single file)
is the whole ceremony. This chapter runs
the template's tests, explains the
silence they pass with, and then breaks
one thing on purpose — because a reader
who has only seen tests pass does not
yet know what a test is *for*.

## The passing run says nothing

The template project from chapter 3
carries tests in both its files: the
library's `add` test, and two in
`main.zig`, one of which builds a small
list, appends a value, and checks it
comes back — the template's own comment
invites you to remove its cleanup line
and watch Zig's test allocator report
the leaked memory, an experiment worth
the two minutes some afternoon.

```bash
zig build test
```

```text
$ zig build test
exit: 0
```

That is all (transcript
`zig-lab/transcripts/t03-template-tests.txt`).
No list of tests, no applause: success
is exit code 0 and silence. The build
system will show its work when asked —
the same run with `--summary all`
reports the steps and reveals there were
*two* test programs behind the one
command, one for the library module and
one for the program module, because a
test run covers one module at a time:

```text
Build Summary: 5/5 steps succeeded
test success
+- run test cached
|  +- compile test debug native cached 39ms MaxRSS:40M
+- run test cached
   +- compile test debug native cached 39ms MaxRSS:40M
```

"CACHED" is the build system saying the
tests ran before and neither the code
nor its inputs changed, so the earlier
verdict stands. Touch a file and the
next run really runs. The silence is a
deliberate manner, shared with `zig
build`: *no news is good news*, and the
exit code is the contract scripts and
editors actually check. Chapter 15
returns to this, because it is also the
first thing that makes a newcomer ask
whether anything happened at all.

## A single file, tested directly

The lab's `zig-lab/snippets/failing_test.zig`
holds a small `add` and two tests of it.
Before the breakage, meet the pieces:

```zig
const std = @import("std");

fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "adding two numbers" {
    try std.testing.expectEqual(@as(i32, 5), add(2, 3));
}
```

A test has a name in quotes — it is how
the test will be introduced when it
fails — and a body of checks. The
working check here is
`std.testing.expectEqual(expected,
actual)`: state the answer you expect
first, then the answer the code gives.
The `@as(i32, 5)` says "the number 5, as
an `i32`", so the comparison is made in
one type. The `try` in front is chapter
7 arriving early: a check that fails
*returns an error* rather than printing
and continuing, and `try` passes that
error up, ending the test.

## The failing test, in full

The file's second test expects ten from
adding 2 and −3. That is wrong — on
purpose, and the file says so in a
comment — and running the file's tests
reports it like this (transcript
`zig-lab/transcripts/t05-failing-test.txt`,
with the middle of the trace trimmed):

```text
$ zig test snippets/failing_test.zig
1/2 failing_test.test.adding two numbers...OK
2/2 failing_test.test.adding a negative number...expected 10, found -1
FAIL (TestExpectedEqual)
... stack trace through std/testing.zig, ending at the test's own line ...
    try std.testing.expectEqual(@as(i32, 10), add(2, -3));
    ^
1 passed; 0 skipped; 1 failed.
error: the following test command failed with exit code 1:
exit: 1
```

Everything a failing test owes you is
here. Each test is counted and named as
it runs (`1/2 ...OK`). The failure
states the two numbers — **expected 10,
found -1** — which settles in one glance
whether the code is wrong or the
expectation is (here, obviously, the
expectation: 2 + −3 has been −1 since
long before Zig). A stack trace walks
from the testing library down to the
exact line of the check, underlined.
The summary counts the whole run: one
passed, one failed. And the command's
exit code is 1, so any script driving
this stops too.

Two habits this teaches. First, **a
failing test is information, not
interruption**: it names the test, shows
both values, and points at the line.
Second, the argument order in
`expectEqual` matters when you read a
failure: everything in this book writes
*expected first*, so "expected 10" is
the test talking and "found -1" is the
code answering.

Check: in the lab's file, correct the
expectation to −1 and re-run. Both tests
report OK, the summary reads `2 passed`,
and the exit code returns to 0 — the
silence of the passing project run,
earned this time.

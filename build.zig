const std = @import("std");
const Build = std.Build;

pub fn build(b: *Build) void {
    // these calls to `b.option` will allow the consumer to pass `.<option-name> = <value>` through `b.dependency(...)`.
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // makes the available a module 'foo' to consumer packages
    // with 'src/foo.zig' as the root source file of said module.
    // also returns a reference to the module for if another module
    // within this build file would also want to import it.
    const foo_mod = b.addModule("foo", .{
        .source_file = Build.FileSource.relative("src/foo.zig"),
        // could add some module deps here, either originating from within this same
        // library, or from another library dependency declared in build.zig.zon
        .dependencies = &[_]Build.ModuleDependency{},
    });

    const bar = b.addExecutable(.{
        .name = "bar", // <== this is the name of the artifact; this is what the consumer should use to get the artifact from `b.dependency(...).artifact(...)`.
        .root_source_file = Build.FileSource.relative("src/bar.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(bar); // <== this is what makes the artifact available to the consumer

    const baz = b.addStaticLibrary(.{
        .name = "baz", // <== ditto
        .root_source_file = Build.FileSource.relative("src/baz.zig"),
        .target = target,
        .optimize = optimize,
    });
    b.installArtifact(baz); // <== ditto

    // the rest of this stuff is just for local testing; not available to the consumer of this library

    const foo_tests = b.addTest(.{
        .root_source_file = Build.FileSource.relative("src/foo-test.zig"),
        .target = target,
        .optimize = optimize,
    });

    // although we exposed the foo module as "foo" to consumer packages,
    // both the consumer packages and us are free to make the module
    // importable under whatever name we'd like.
    // this makes the foo module available to the "foo_tests" test executable
    // as "foo-lib".
    foo_tests.addModule("foo-lib", foo_mod);
    // don't forget to link the definition for foo.sub,
    // which is defined in the baz static library artifact.
    foo_tests.linkLibrary(baz);

    const run_foo_tests = b.addRunArtifact(foo_tests);
    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&run_foo_tests.step);
}

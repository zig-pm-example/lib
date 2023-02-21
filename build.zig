const std = @import("std");

pub fn build(b: *std.Build) void {
    // these calls to `b.option` will allow the consumer to pass `.<option-name> = <value>` through `b.dependency(...)`.
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // makes the available a module 'foo' to consumer packages
    // with 'src/foo.zig' as the root source file of said module.
    b.addModule(.{
        .name = "foo",
        .source_file = std.Build.FileSource.relative("src/foo.zig"),
        // could add some module deps here, either originating from within this same
        // library, or from another library dependency declared in build.zig.zon
        .dependencies = &[_]std.Build.ModuleDependency{},
    });

    const bar = b.addExecutable(.{
        .name = "bar", // <== this is the name of the artifact; this is what the consumer should use to get the artifact from `b.dependency(...).artifact(...)`.
        .root_source_file = std.Build.FileSource.relative("src/bar.zig"),
        .target = target,
        .optimize = optimize,
    });
    bar.install(); // <== this is what makes the artifact available to the consumer

    const baz = b.addStaticLibrary(.{
        .name = "baz", // <== ditto
        .root_source_file = std.Build.FileSource.relative("src/baz.zig"),
        .target = target,
        .optimize = optimize,
    });
    baz.install(); // <== ditto

    // the rest of this stuff is just for local testing; not seen by the consumer of this library

    const main_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/say-hi.zig" },
        .target = target,
        .optimize = optimize,
    });

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}

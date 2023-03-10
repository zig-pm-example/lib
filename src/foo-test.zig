const std = @import("std");
const foo = @import("foo-lib");

test "foo.add" {
    try std.testing.expectEqual(@as(i32, 3), foo.add(1, 2));
}
test "foo.sub" {
    try std.testing.expectEqual(@as(i32, -1), foo.sub(1, 2));
}

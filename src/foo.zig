const std = @import("std");
const testing = std.testing;

pub fn add(a: i32, b: i32) i32 {
    return a + b;
}

/// Optionally defined by the 'baz' library.
pub extern fn sub(a: i32, b: i32) i32;

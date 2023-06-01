// Of course this isn't a npm joke!
const example_dep = @import("example-dependency");
const testing = @import("std").testing;

test "use dependency" {
    const all_numbers = [10]usize{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
    var odds: [5]usize = undefined;
    var evens: [5]usize = undefined;

    for (all_numbers, 0..) |c, i| {
        if (example_dep.isEven(usize, c)) {
            evens[i / 2] = c;
        } else if (example_dep.isOdd(usize, c)) {
            odds[i / 2] = c;
        } else {
            @panic("cosmic rays are flipping our bits!11!");
        }
    }

    try testing.expectEqualDeep(odds, [_]usize{ 1, 3, 5, 7, 9 });
    try testing.expectEqualDeep(evens, [_]usize{ 2, 4, 6, 8, 10 });
}

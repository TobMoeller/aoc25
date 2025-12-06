const std = @import("std");

var grid: std.ArrayList([]u8) = undefined;

pub fn challenge1() !void {
    std.debug.print("day 4 - challenge 1\n", .{});

    var gpa: std.heap.DebugAllocator(.{}) = .init;
    defer _ = gpa.deinit();

    const allocator = gpa.allocator();

    grid = .empty;
    defer deinitGrid(allocator) catch unreachable;

    try readFile(allocator);

    var count: usize = 0;
    for (grid.items, 0..) |line, y| {
        for (grid.items[y], 0..) |entry, x| {
            if (entry == '@' and checkSurroundings(y, x)) {
                count += 1;
                grid.items[y][x] = 'X';
            }
        }
        _ = line;
        // std.debug.print("{s}\n", .{line});
    }



    std.debug.print("result: {d}\n", .{count});
}

fn checkSurroundings(y: usize, x: usize) bool {
    var count: usize = 0;
    var yIndex = if (y > 0) y - 1 else 0;
    while (yIndex <= y + 1) : (yIndex += 1) {

        var xIndex = if (x > 0) x - 1 else 0;
        while (xIndex <= x + 1) : (xIndex += 1) {

            const entry = get(yIndex, xIndex);

            if (!(yIndex == y and xIndex == x) // exclude checked entry itself
                and (entry == '@' or entry == 'X')
            ) {
                count += 1;
                if (count > 3) return false;
            }
        }
    }
    return true;
}

fn get(y: usize, x: usize) ?u8 {
    if (y < grid.items.len and x < grid.items[y].len) {
        return grid.items[y][x];
    }
    return null;
}

fn readFile(allocator: std.mem.Allocator) !void {
    const file = try std.fs.cwd().openFile("./src/input/day4_challenge1", .{.mode = .read_only});
    defer file.close();

    var fileBuffer: [1024]u8 = undefined;
    var reader = file.reader(&fileBuffer);

    while (try reader.interface.takeDelimiter('\n')) |line| {
        std.debug.print("{s}\n", .{line});
        try grid.append(allocator, try allocator.dupe(u8, line));
    }
}

fn deinitGrid(allocator: std.mem.Allocator) !void {
    for (grid.items) |item| {
        allocator.free(item);
    }
    grid.deinit(allocator);
}

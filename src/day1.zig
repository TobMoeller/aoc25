const std = @import("std");

pub fn challenge1() !void {
    std.debug.print("day 1 - challenge 1\n", .{});

    const inputFile = try std.fs.cwd().openFile("./src/input/day1_challenge1", .{ .mode = .read_only });
    defer inputFile.close();
    var fileBuffer: [1024]u8 = undefined;
    var fileReader = inputFile.reader(&fileBuffer);

    var i: i32 = 50;
    var countZero: u32 = 0;

    while (try fileReader.interface.takeDelimiter('\n')) |line| {
        if (line.len < 2) {
            break;
        }
        const num = try std.fmt.parseInt(i32, line[1..line.len], 10);

        switch (line[0]) {
            'L' => {
                std.debug.print("{d} - {d} = {d}\n", .{i, num, (i - num)});
                i -= num;
            },
            'R' => {
                std.debug.print("{d} + {d} = {d}\n", .{i, num, (i+num)});
                i += num;
            },
            else => {
                std.debug.print("Invalid start: {s}", .{line});
                break;
            }
        }

        if (i == 0 or @mod(i, 100) == 0) {
            std.debug.print("count: {d}\n", .{countZero});
            countZero += 1;
        }
    }

    std.debug.print("result: {d}\n", .{countZero});
}

pub fn challenge2() !void {
    std.debug.print("day 1 - challenge 2\n", .{});

    const inputFile = try std.fs.cwd().openFile("./src/input/day1_challenge1", .{ .mode = .read_only });
    defer inputFile.close();
    var fileBuffer: [1024]u8 = undefined;
    var fileReader = inputFile.reader(&fileBuffer);

    var start: i32 = 50;
    var countZero: u32 = 0;

    while (try fileReader.interface.takeDelimiter('\n')) |line| {
        if (line.len < 2) {
            break;
        }
        const diff = try std.fmt.parseInt(i32, line[1..line.len], 10);
        const relativeDiff = try std.math.mod(i32, diff, 100);
        // add full rotations of movement
        const rotations = @abs(try std.math.divTrunc(i32, diff, 100));
        countZero += rotations;
        const modulo = try std.math.mod(i32, start, 100);

        switch (line[0]) {
            'L' => {
                std.debug.print("{d} - {d} = {d}\n", .{start, diff, (start - diff)});
                if (relativeDiff >= modulo and modulo != 0) {
                    std.debug.print("  {d} >= {d}\n", .{relativeDiff, modulo});
                    countZero += 1;
                }
                start -= diff;
            },
            'R' => {
                std.debug.print("{d} + {d} = {d}\n", .{start, diff, (start + diff)});
                if (relativeDiff >= (100 - modulo)) {
                    std.debug.print("  {d} >= {d}\n", .{relativeDiff, (100-modulo)});
                    countZero += 1;
                }
                start += diff;
            },
            else => {
                std.debug.print("Invalid start: {s}", .{line});
                break;
            }
        }
        std.debug.print("  {d} rotates {d}\n", .{diff, rotations});

        // std.debug.print("{d} % {d} = {d}\n", .{start, 100, try std.math.mod(i32, start, 100)});
        // if (try std.math.mod(i32, start, 100) == 0) {
        //     std.debug.print("count: {d}\n", .{countZero});
        //     countZero += 1;
        // }
    }

    std.debug.print("result: {d}\n", .{countZero}); // 5941
}

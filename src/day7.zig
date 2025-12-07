const std = @import("std");

pub fn challenge1() !void {
    std.debug.print("day 7 - challenge 1\n", .{});
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var input: std.ArrayList([]u8) = try .initCapacity(allocator, 1024);
    defer {
        for (input.items) |item| {
            allocator.free(item);
        } 
        input.deinit(allocator);
    }

    const file = try std.fs.cwd().openFile("./src/input/day7_challenge1", .{.mode = .read_only});
    defer file.close();

    var fileBuffer: [1024 * 10]u8 = undefined;
    var reader = file.reader(&fileBuffer);

    while (try reader.interface.takeDelimiter('\n')) |line| {
        try input.append(allocator, try allocator.dupe(u8, line));
    }

    input.items[1][std.mem.indexOfScalar(u8, input.items[0], 'S').?] = '|';
    var i: usize = 1;
    std.debug.print("{s}\n", .{input.items[0]});

    var splits: u64 = 0;

    while (i < input.items.len - 1) : (i += 1) {
        const line = &input.items[i];
        const next = &input.items[i+1];

        for (0..line.*.len) |j| {
            if (line.*[j] == '|') {
                if (next.*[j] == '^') {
                    next.*[j-1] = '|';
                    next.*[j+1] = '|';
                    splits += 1;
                } else {
                    next.*[j] = '|';
                }
            }
        }
        std.debug.print("{s}\n", .{input.items[i]});
    }

    std.debug.print("{s}\n", .{input.items[input.items.len-1]});

    std.debug.print("result: {d}\n", .{splits});
}

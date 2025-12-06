const std = @import("std");

const Range = struct {
    min: u64,
    max: u64,
};

var ranges: std.ArrayList(Range) = undefined; // TODO sorted with combined ranges??

pub fn challenge1() !void {
    std.debug.print("day 3 - challenge 1\n", .{});
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    ranges = .empty;
    defer ranges.deinit(allocator);

    // const input = "123459";
    const file = try std.fs.cwd().openFile("./src/input/day5_challenge1", .{.mode = .read_only});
    defer file.close();

    var fileBuffer: [1024]u8 = undefined;
    var reader = file.reader(&fileBuffer);

    var count: usize = 0;

    while (try reader.interface.takeDelimiter('\n')) |line| {
        if (line.len < 2) break;

        var split = std.mem.splitScalar(u8, line, '-');

        try ranges.append(allocator, .{
            .min = try std.fmt.parseInt(u64, split.first(), 10),
            .max = try std.fmt.parseInt(u64, split.rest(), 10),
        });
    }

    while (try reader.interface.takeDelimiter('\n')) |line| {
        const num: u64 = try std.fmt.parseInt(u64, line, 10);
        for (ranges.items) |range| {
            if (num >= range.min and num <= range.max) {
                count += 1;
                break;
            }
        }
    }

    std.debug.print("result: {d}\n", .{count});
}

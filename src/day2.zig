const std = @import("std");

pub fn challenge1() !void { // 18952700150
    std.debug.print("day 2 - challenge 1\n", .{});
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var hashMap: std.hash_map.AutoHashMap(u64, void) = .init(allocator);
    defer hashMap.deinit();

    const inputFile = try std.fs.cwd().openFile("./src/input/day2_challenge1", .{ .mode = .read_only });
    defer inputFile.close();
    var fileBuffer: [1024]u8 = undefined;
    var fileReader = inputFile.reader(&fileBuffer);

    var count: u64 = 0;

    while (try fileReader.interface.takeDelimiter(',')) |range| {
        if (range.len < 3) {
            break;
        }
        var rangeIterator = std.mem.splitScalar(u8, range, '-');

        const startString = rangeIterator.first();
        const start = try std.fmt.parseInt(u64, startString, 10);

        const endString = rangeIterator.rest();
        const end = try std.fmt.parseInt(
            u64,
            if (endString[endString.len - 1] == '\n') endString[0..endString.len-1] else endString,
            10
        );

        try findPatterns(&hashMap, start, end);
    }

    var it = hashMap.iterator();

    while (it.next()) |ent| {
        count += ent.key_ptr.*;
    }
    std.debug.print("result: {d}\n", .{count});
}

fn findPatterns(hashSet: *std.AutoHashMap(u64, void), start: u64, end: u64) !void {
    var i = start;

    while (i <= end) : (i += 1) {
        if (i < 11) continue;
        var numBuf: [27]u8 = undefined;
        const len = std.fmt.printInt(&numBuf, i, 10, .lower, .{});
        const num = numBuf[0..len];
        var isPattern = false;

        if (len % 2 == 0) {
            isPattern = std.mem.eql(u8, num[0..len/2], num[len/2..len]);
        }
        if (isPattern) {
            try hashSet.put(i, {});
        }
    }
}

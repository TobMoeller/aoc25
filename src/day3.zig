const std = @import("std");

pub fn challenge1() !void {
    std.debug.print("day 3 - challenge 1\n", .{});
    // const input = "123459";
    const file = try std.fs.cwd().openFile("./src/input/day3_challenge1", .{.mode = .read_only});
    defer file.close();

    var fileBuffer: [1024]u8 = undefined;
    var reader = file.reader(&fileBuffer);

    var joltage: u32 = 0;

    while (try reader.interface.takeDelimiter('\n')) |line| {
        joltage += findLargestJoltage(line);
        std.debug.print("{d}\n", .{joltage});
    }

    std.debug.print("result: {d}\n", .{joltage});
}

fn findLargestJoltage(input: []const u8) u8 {
    var largest: u8 = 0;
    var secondLargest: u8 = 0;

    for (input, 0..) |value, i| {
        const joltage: u8 = value - '0';

        if ((largest == 0 or joltage > largest) 
            and i < input.len - 1 // if the last entry is higher than the second to last
        ) {
            largest = joltage;
            secondLargest = 0;
            continue;
        }

        if (secondLargest == 0 or joltage > secondLargest) {
            secondLargest = joltage;
            continue;
        }
    }

    return largest * 10 + secondLargest;
}

pub fn challenge2() !void {
    std.debug.print("day 3 - challenge 2\n", .{});
    const file = try std.fs.cwd().openFile("./src/input/day3_challenge1", .{.mode = .read_only});
    defer file.close();

    var fileBuffer: [1024]u8 = undefined;
    var reader = file.reader(&fileBuffer);

    var joltage: u64 = 0;

    while (try reader.interface.takeDelimiter('\n')) |line| {
        joltage += try findLargestJoltage2(line);
    }

    std.debug.print("result: {d}\n", .{joltage});
}

fn findLargestJoltage2(input: []const u8) !u64 {
    var largest: [12]u8 = .{0}**12;
    var temp: usize = 0;
    for (0..12) |i| {
        const subString = input[temp..input.len-(12-i-1)];
        const index = findLargestIndex(subString);
        largest[i] = subString[index];
        temp += index + 1;
    }

    return try std.fmt.parseInt(u64, &largest, 10);
}

fn findLargestIndex(input: []const u8) usize {
    var largestIndex: usize = 0;
    for (input, 0..) |value, i| {
        if (value == '9') return i;

        if (value > input[largestIndex]) {
            largestIndex = i;
        }
    }
    return largestIndex;
}

const std = @import("std");

const Operator = enum {
    addition,
    multiplication,
    fn fromChar(c: u8) Operator {
        return switch (c) {
            '*' => .multiplication,
            '+' => .addition,
            else => unreachable,
        };
    }
    fn calc(self: Operator, a: u64, b: u64) u64 {
        return switch (self) {
            .addition => a + b,
            .multiplication => a * b,
        };
    }
};

const Problem = struct {
    operands: [4]u32,
    operator: Operator,
    fn solve(self: Problem) u64 {
        var res: u64 = @intCast(self.operands[0]);
        for (1..4) |i| {
            res = self.operator.calc(res, @intCast(self.operands[i]));
        }
        return res;
    }
};

var problems: std.ArrayList(Problem) = undefined;

pub fn challenge1() !void {
    std.debug.print("day 6 - challenge 1\n", .{});
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    problems = .empty;
    defer problems.deinit(allocator);

    const file = try std.fs.cwd().openFile("./src/input/day6_challenge1", .{.mode = .read_only});
    defer file.close();

    var fileBuffer: [1024 * 10]u8 = undefined;
    var reader = file.reader(&fileBuffer);

    var total: u64 = 0;

    var index: usize = 0;
    while (try reader.interface.takeDelimiter('\n')) |line| {

        var split = std.mem.splitScalar(u8, line, ' ');
        var probIndex: usize = 0;

        while (split.next()) |value| {
            if (value.len > 0) {
                if (index == 0) {
                    // std.debug.print("{d} ", .{try std.fmt.parseInt(u32, value, 10)});
                    try problems.append(allocator, .{
                        .operands = .{ try std.fmt.parseInt(u32, value, 10), 0, 0, 0 },
                        .operator = undefined,
                    });
                } else if (index < 4) {
                    problems.items[probIndex].operands[index] = try std.fmt.parseInt(u32, value, 10);
                } else {
                    problems.items[probIndex].operator = Operator.fromChar(value[0]);
                }
                probIndex += 1;
            }
        }
        index += 1;
    }

    for (problems.items) |problem| {
        const result = problem.solve();
        std.debug.print("{d}\n", .{result});
        total += problem.solve();
    }

    std.debug.print("result: {d}\n", .{total});
}

const Problem2 = struct {
    operands: std.ArrayList(u64) = .empty,
    operator: Operator = undefined,
    fn solve(self: Problem2) u64 {
        var res: u64 = self.operands.items[0];
        for (1..self.operands.items.len) |i| {
            res = self.operator.calc(res, self.operands.items[i]);
        }
        return res;
    }
};
var problems2: std.ArrayList(Problem2) = undefined;

pub fn challenge2() !void {
    // parse char by char, look for spaces in all 5 cols simultaneously to separate
    // reread every col into it's own line for easy parsing?
    std.debug.print("day 6 - challenge 2\n", .{});
    var gpa: std.heap.DebugAllocator(.{}) = .init;
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    problems2 = .empty;
    defer {
        for (0..problems2.items.len) |i| {
            problems2.items[i].operands.deinit(allocator);
        }
        problems2.deinit(allocator);
    }

    const file = try std.fs.cwd().openFile("./src/input/day6_challenge1", .{.mode = .read_only});
    defer file.close();

    var fileBuffer: [1024 * 10]u8 = undefined;
    var reader = file.reader(&fileBuffer);

    var input: [5][]const u8 = undefined;
    defer {
        for (input) |line| {
            allocator.free(line);
        }
    }

    var i: usize = 0;
    while (try reader.interface.takeDelimiter('\n')) |line| : (i += 1) {
        input[i] = try allocator.dupe(u8, line);
    }

    i = 0;
    var j: usize = 0;
    var tempProblem: Problem2 = .{};

    while (i < input[0].len) : (i += 1) {

        if (input[4][i] != ' ') {
            tempProblem.operator = Operator.fromChar(input[4][i]);
        }

        if (i == input[0].len - 1
            or (
                input[0][i] == ' ' and input[1][i] == ' '
                and input[2][i] == ' ' and input[3][i] == ' '
            )
        ) {
            const end = if (i == input[0].len - 1) i + 1 else i;
            for (j..end) |k| {
                const num: [4]u8 = .{
                    input[0][k],
                    input[1][k],
                    input[2][k],
                    input[3][k],
                };
                try tempProblem.operands.append(allocator, try getNumber(num[0..]));
            }
            try problems2.append(allocator, tempProblem);
            tempProblem = .{};
            j = i + 1;
        }
    }

    var total: u64 = 0;
    for (problems2.items) |problem| {
        for (problem.operands.items) |num| {
            std.debug.print("{d} ", .{num});
        }
        total += problem.solve();
        std.debug.print("{any}\n", .{problem.operator});
    }

    std.debug.print("\n", .{});
    std.debug.print("result: {d}\n", .{total});
}

fn getNumber(string: []const u8) !u64 {
    const trimmed = std.mem.trim(u8, string, " ");
    return try std.fmt.parseInt(u64, trimmed, 10);
}




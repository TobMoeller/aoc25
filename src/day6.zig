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
};

const Problem = struct {
    operands: [4]u32,
    operator: Operator,
    fn solve(self: Problem) u64 {
        switch (self.operator) {
            .multiplication => {
                var res: u64 = 0;
                res = self.operands[0];
                for (1..4) |i| {
                    res *= self.operands[i];
                }
                return res;
            },
            .addition => {
                var res: u64 = 0;
                for (0..4) |i| {
                    res += self.operands[i];
                }
                return res;
            },
        }
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

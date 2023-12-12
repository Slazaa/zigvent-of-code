const std = @import("std");

const digits_name_char = .{
    .{ "one", '1' },
    .{ "two", '2' },
    .{ "three", '3' },
    .{ "four", '4' },
    .{ "five", '5' },
    .{ "six", '6' },
    .{ "seven", '7' },
    .{ "eight", '8' },
    .{ "nine", '9' },
};

fn digitCharFromName(name: []const u8) !u8 {
    inline for (digits_name_char) |digit_name_char| {
        const digit_name = digit_name_char[0];
        const digit_char = digit_name_char[1];

        if (std.mem.eql(u8, name, digit_name)) {
            return digit_char;
        }
    }

    return error.InvalidName;
}

fn getFirstDigit(string: []const u8) ?u8 {
    var substring = string;

    while (substring.len != 0) : (substring = substring[1..]) {
        inline for (digits_name_char) |digit_name_char| {
            const digit_name = digit_name_char[0];

            if (std.mem.startsWith(u8, substring, digit_name)) {
                return digitCharFromName(digit_name) catch unreachable;
            }
        }

        const char = substring[0];

        if (std.ascii.isDigit(char)) {
            return char;
        }
    }

    return null;
}

fn getLastDigit(string: []const u8) ?u8 {
    var substring = string;

    while (substring.len != 0) : (substring = substring[0 .. substring.len - 1]) {
        inline for (digits_name_char) |digit_name_char| {
            const digit_name = digit_name_char[0];

            if (std.mem.endsWith(u8, substring, digit_name)) {
                return digitCharFromName(digit_name) catch unreachable;
            }
        }

        const char = substring[substring.len - 1];

        if (std.ascii.isDigit(char)) {
            return char;
        }
    }

    return null;
}

pub fn main() !void {
    var input_file = try std.fs.cwd().openFile("2023/day1/input.txt", .{});
    defer input_file.close();

    var buffer: [100]u8 = undefined;

    var line_num: usize = 1;
    var sum: u32 = 0;

    while (try input_file.reader().readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        const first_digit = getFirstDigit(line) orelse {
            std.log.err("Invalid input, no digit line {}", .{line_num});
            return;
        };

        const last_digit = getLastDigit(line) orelse unreachable;

        const digits = [_]u8{ first_digit, last_digit };

        sum += try std.fmt.parseInt(u32, &digits, 10);
        line_num += 1;
    }

    const stdout = std.io.getStdOut().writer();

    try stdout.print("Result: {}\n", .{sum});
}

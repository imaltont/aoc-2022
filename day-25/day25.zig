const std = @import("std");

pub fn main() anyerror!void {
    std.debug.print("Part 1: ", .{});
    const sum = try get_decimal_sum("./resources/input");
    decimal_to_snafu(sum);
    std.debug.print("\n", .{});
}

fn get_decimal_sum(path: []const u8) anyerror!u64 {
    var sum: u64 = 0;
    var file = try std.fs.cwd().openFile(path, .{});
    defer file.close();
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1000]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        sum = sum + snafu_to_decimal(line);
    }
    return sum;
}

fn snafu_to_decimal(snafu: []const u8) u64 {
    const max: i64 = @intCast(i64, snafu.len) - 1;
    var sum: i64 = 0;
    var index: i64 = 0;
    for (snafu) |num| {
        var snafu_val: i64 = parse_snafu(num);
        sum += std.math.pow(i64, 5, max - index) * snafu_val;
        index += 1;
    }
    return @intCast(u64, sum);
}

fn parse_snafu(snafu: u8) i64 {
    if (snafu == '2') {
        return 2;
    } else if (snafu == '1') {
        return 1;
    } else if (snafu == '0') {
        return 0;
    } else if (snafu == '-') {
        return -1;
    } else if (snafu == '=') {
        return -2;
    }
    return 0;
}

fn decimal_to_snafu(dec: u64) void {
    if (dec == 0) {
        return;
    }
    const base: u64 = 5;
    const legal_chars = [5]u8{ '0', '1', '2', '=', '-' };
    decimal_to_snafu(@divFloor(dec + 2, base));
    std.debug.print("{c}", .{legal_chars[@as(usize, @mod(dec, base))]});
}

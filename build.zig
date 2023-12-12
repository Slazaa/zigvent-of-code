const std = @import("std");

const Build = std.Build;

pub fn build(b: *Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    inline for (2015..2024) |year| {
        inline for (1..32) |day| {
            const year_day_str = std.fmt.comptimePrint("{}-{}", .{ year, day });

            const exe = b.addExecutable(.{
                .name = year_day_str,
                .root_source_file = .{ .path = std.fmt.comptimePrint("{}/day{}/main.zig", .{ year, day }) },
                .target = target,
                .optimize = optimize,
            });

            const run_cmd = b.addRunArtifact(exe);
            run_cmd.step.dependOn(b.getInstallStep());

            const run_step = b.step(year_day_str, "Run day");
            run_step.dependOn(&run_cmd.step);
        }
    }
}

class Arx < Formula
  desc "Local arXiv cache with CLI, daemon, and MCP server"
  homepage "https://github.com/eric-tramel/arx"
  url "https://github.com/eric-tramel/arx/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "8e1e68cf791892a65b444bd544108ed7712d34314db57627c480be0204106669"
  license "MIT"
  head "https://github.com/eric-tramel/arx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "rust" => :build

  def install
    # Tarballs up to and including v0.1.0 ship a developer-only
    # .cargo/config.toml forcing rustc-wrapper = "sccache"; Homebrew
    # builders do not have sccache. Removed upstream in e0627b0, so this
    # guard is a no-op for later releases.
    rm(".cargo/config.toml") if File.exist?(".cargo/config.toml")

    # Share one target dir across the three workspace binaries so
    # dependencies compile once instead of three times.
    ENV["CARGO_TARGET_DIR"] = (buildpath/"target").to_s

    system "cargo", "install", *std_cargo_args(path: "crates/arx-cli")
    system "cargo", "install", *std_cargo_args(path: "crates/arxd")
    system "cargo", "install", *std_cargo_args(path: "crates/arx-mcp")
  end

  test do
    ENV["XDG_CACHE_HOME"] = (testpath/"cache").to_s

    assert_match "Usage: arx", shell_output("#{bin}/arx --help")
    assert_match "Usage: arxd", shell_output("#{bin}/arxd --help")
    assert_match "Usage: arx-mcp", shell_output("#{bin}/arx-mcp --help")

    assert_equal "#{testpath}/cache/arx\n", shell_output("#{bin}/arx cache-dir")
  end
end

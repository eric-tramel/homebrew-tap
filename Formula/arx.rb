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

  bottle do
    root_url "https://github.com/eric-tramel/homebrew-tap/releases/download/arx-0.1.0"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "9351c6cb7e7bc2310b06791b2a24389e5a4236f701124a4f66ab1e8b19f44c2a"
    sha256 cellar: :any,                 x86_64_linux: "95ef77b047ec6ba9708a92f705b7043644bdedaaba68ade8b5a6fdd1bcc51f84"
  end

  depends_on "rust" => :build

  def install
    # Tarballs up to and including v0.1.0 ship a developer-only
    # .cargo/config.toml forcing rustc-wrapper = "sccache"; Homebrew
    # builders do not have sccache. Removed upstream in e0627b0, so this
    # guard is a no-op for later releases.
    rm(".cargo/config.toml") if File.exist?(".cargo/config.toml")

    # Reuse one target directory across workspace binaries so dependencies
    # compile once instead of once per cargo install.
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

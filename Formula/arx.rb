class Arx < Formula
  desc "Local arXiv cache with CLI, daemon, and MCP server"
  homepage "https://github.com/eric-tramel/arx"
  url "https://github.com/eric-tramel/arx/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "4b46d1f170cf9227ca7fcb891da70d1e4a15fea09f13808c8d145180c13eb120"
  license "MIT"
  head "https://github.com/eric-tramel/arx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/eric-tramel/homebrew-tap/releases/download/arx-0.1.1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "479b423cf326b8aba14c6e816a391c92e3f929323d6093247dc5c4e4d1ee5ebe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8de7aba09f93c5487685ad7d312d84e0cc05f4f8dbf278468b93d4b851ddaaf"
    sha256 cellar: :any,                 x86_64_linux:  "bcd1d177671577b8065dcd07aec456bb8268da83f19c203527a8c1abc6261fcc"
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

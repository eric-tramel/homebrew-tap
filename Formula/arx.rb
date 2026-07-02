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
    root_url "https://github.com/eric-tramel/homebrew-tap/releases/download/arx-0.1.0"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10ce03a6200d74e99abbbd2f214f12cba4e11a5bf81d0e5ad24d3cc9a100ea8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fb9cc051aefa9210bb11a7737f247105ff949ad784a7dd0fccbd1231e60499a8"
    sha256 cellar: :any,                 x86_64_linux:  "7b7da7f5da69a95a581a7aaab967e1a82c1260dd90a83c407755ab709673622f"
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

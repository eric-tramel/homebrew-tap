class Arx < Formula
  desc "Local arXiv cache with CLI, daemon, and MCP server"
  homepage "https://github.com/eric-tramel/arx"
  url "https://github.com/eric-tramel/arx/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "70e046e59048ab6658d41cda4cded0781894fcc0ef11e0141e48968fc477abd8"
  license "MIT"
  head "https://github.com/eric-tramel/arx.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    root_url "https://github.com/eric-tramel/homebrew-tap/releases/download/arx-0.1.2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e21e9f3c28482ae27087d3cf08c8abcbd1e0bf23bb694d6696f6c60e2aa79d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf45f0e3bb5e9d189bda0e13bf9981a17ae1302fbbaa4622f7159c2cd837a640"
    sha256 cellar: :any,                 x86_64_linux:  "9c9e5deab22f76d85051c5f4a2ae8c027e89b971ca36bc4a2cfbc3fe755584bb"
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

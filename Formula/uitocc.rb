class Uitocc < Formula
  desc "Screen context provider for Claude Code via MCP"
  homepage "https://github.com/moeki0/uitocc"
  url "https://github.com/moeki0/uitocc/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "b6a89626e92fc6c48efa8cd9c1d563e7fbeed68ac18c5bff7a334eb7af7c9ab0"
  license "MIT"

  resource "bun" do
    on_arm do
      url "https://github.com/oven-sh/bun/releases/latest/download/bun-darwin-aarch64.zip"
    end
    on_intel do
      url "https://github.com/oven-sh/bun/releases/latest/download/bun-darwin-x64.zip"
    end
  end

  def install
    resource("bun").stage do
      buildpath.install Dir["bun-*/bun"].first => "bun"
    end
    chmod 0755, buildpath/"bun"
    bun = buildpath/"bun"

    system bun, "install", "--frozen-lockfile"
    system bun, "build", "--compile", "cli.ts", "--outfile", "uitocc"
    system "swiftc", "ax_text.swift", "-o", "uitocc-ax-text", "-O"
    system "swiftc", "send.swift", "-o", "uitocc-send", "-O"
    system "swiftc", "embed.swift", "-o", "uitocc-embed", "-O"
    bin.install "uitocc"
    bin.install "uitocc-ax-text"
    bin.install "uitocc-send"
    bin.install "uitocc-embed"
  end

  def caveats
    <<~EOS
      Grant Accessibility and Screen Recording permissions to your terminal app.

      Register the MCP server with Claude Code:
        claude mcp add -s user uitocc -- #{bin}/uitocc mcp

      Start Claude Code with channels enabled:
        claude --dangerously-load-development-channels server:uitocc

      Start the watch daemon to observe screen context:
        uitocc watch
    EOS
  end

  test do
    assert_match "uitocc", shell_output("#{bin}/uitocc 2>&1", 0)
  end
end

class Uitocc < Formula
  desc "Screen context provider for Claude Code via MCP"
  homepage "https://github.com/moeki0/uitocc"
  version "0.9.1"
  license "MIT"

  on_arm do
    url "https://github.com/moeki0/uitocc/releases/download/v0.9.1/uitocc-darwin-arm64.tar.gz"
    sha256 "ec3eab253f19e574ff1ac8c8a9b32a822520078ebeeb44ae55feab8241b51fdb"
  end

  def install
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

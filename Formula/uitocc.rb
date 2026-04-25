class Uitocc < Formula
  desc "Screen context provider for Claude Code via MCP"
  homepage "https://github.com/moeki0/uitocc"
  version "0.9.5"
  license "MIT"

  on_arm do
    url "https://github.com/moeki0/uitocc/releases/download/v0.9.5/uitocc-darwin-arm64.tar.gz"
    sha256 "f522f4827293353c483418a1553f7b4858429e5d9faeea3e37d75073fb758094"
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

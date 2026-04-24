class Uitocc < Formula
  desc "Screen context provider for Claude Code via MCP"
  homepage "https://github.com/moeki0/uitocc"
  url "https://github.com/moeki0/uitocc/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "53c6fec3d65a704d08cccc8d79ab39108fbe71922c71021ad3ed4a036a7493cc"
  license "MIT"

  depends_on :macos
  depends_on "bun" => :build

  def install
    system "bun", "install"
    system "bun", "build", "--compile", "cli.ts", "--outfile", "uitocc"
    system "swiftc", "ax_text.swift", "-o", "uitocc-ax-text", "-O"
    system "swiftc", "send.swift", "-o", "uitocc-send", "-O"

    bin.install "uitocc"
    bin.install "uitocc-ax-text"
    bin.install "uitocc-send"
  end

  def caveats
    <<~EOS
      Grant Accessibility and Screen Recording permissions to your terminal app.

      Start the daemon:
        uitocc daemon

      Register the MCP server with Claude Code:
        claude mcp add -s user uitocc -- #{bin}/uitocc mcp

      Enable channels in ~/.claude/settings.json:
        { "experimentalFeatures": { "channels": true } }
    EOS
  end

  test do
    assert_match "uitocc", shell_output("#{bin}/uitocc 2>&1", 0)
  end
end

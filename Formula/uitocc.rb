class Uitocc < Formula
  desc "Screen context provider for Claude Code via MCP"
  homepage "https://github.com/moeki0/uitocc"
  url "https://github.com/moeki0/uitocc/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "48bbfef868ae8f908692882c4cb2ecac07dc80a04870f71ce0f9cfde60a79710"
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

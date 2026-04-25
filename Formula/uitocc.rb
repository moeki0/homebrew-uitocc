class Uitocc < Formula
  desc "Screen context provider for Claude Code via MCP"
  homepage "https://github.com/moeki0/uitocc"
  url "https://github.com/moeki0/uitocc/archive/refs/tags/v0.9.34.tar.gz"
  sha256 "09878fec2bb3c0376cb6c07d82af1fc24e728ac9391ac1d9b18db456b1cf8cdd"
  license "MIT"

  resource "bun" do
    on_arm do
      url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.13/bun-darwin-aarch64.zip"
      sha256 "5467e3f65dba526b9fea98f0cce04efafc0c63e169733ec27b876a3ad32da190"
    end
    on_intel do
      url "https://github.com/oven-sh/bun/releases/download/bun-v1.3.13/bun-darwin-x64.zip"
      sha256 :no_check
    end
  end

  def install
    resource("bun").stage do
      bun_bin = Dir["bun-*/bun"].first || "bun"
      buildpath.install bun_bin => "bun"
    end
    chmod 0755, buildpath/"bun"
    bun = (buildpath/"bun").to_s

    system bun, "install", "--frozen-lockfile"
    system bun, "build", "--compile", "cli.ts", "--outfile", "uitocc"
    system "swiftc", "ax_text.swift", "-o", "uitocc-ax-text", "-O"
    system "swiftc", "send.swift", "-o", "uitocc-send", "-O"
    system "swiftc", "embed.swift", "-o", "uitocc-embed", "-O"
    system "swiftc", "audio_capture.swift", "-o", "uitocc-audio-capture", "-O",
           "-framework", "AVFoundation", "-framework", "CoreAudio"
    system "swiftc", "event_monitor.swift", "-o", "uitocc-event-monitor", "-O"
    bin.install "uitocc"
    bin.install "uitocc-ax-text"
    bin.install "uitocc-send"
    bin.install "uitocc-embed"
    bin.install "uitocc-audio-capture"
    bin.install "uitocc-event-monitor"
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

      For audio capture, install BlackHole and set up a multi-output device:
        brew install --cask blackhole-2ch
      Then configure a multi-output device in Audio MIDI Setup.
    EOS
  end

  test do
    assert_match "uitocc", shell_output("#{bin}/uitocc 2>&1", 0)
  end
end

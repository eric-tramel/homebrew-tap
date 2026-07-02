# Eric-tramel Tap

Homebrew formulae for [eric-tramel](https://github.com/eric-tramel) projects.

## How do I install these formulae?

`brew install eric-tramel/tap/<formula>`

Or `brew tap eric-tramel/tap` and then `brew install <formula>`.

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "eric-tramel/tap"
brew "<formula>"
```

## Formulae

| Formula | Description |
| --- | --- |
| `arx` | Local arXiv cache with CLI (`arx`), daemon (`arxd`), and MCP server (`arx-mcp`) |

## Release flow

Tagging `vX.Y.Z` in [eric-tramel/arx](https://github.com/eric-tramel/arx) is
fully automated end to end (requires the `TAP_BUMP_TOKEN` secret in that repo):

1. The upstream release workflow computes the source tarball sha256 and opens
   a `bump-arx-vX.Y.Z` pull request here updating `url`/`sha256` in
   `Formula/arx.rb`.
2. `brew test-bot` builds the formula from source on all CI platforms and
   uploads bottles as artifacts.
3. When test-bot succeeds on a non-draft `bump-arx-*` pull request, the
   **brew pr-pull** workflow runs automatically: it merges the bump, attaches
   the bottle block, uploads bottles to a GitHub release on this repository,
   and pushes to `main`.

Draft `bump-arx-*` pull requests (opened by upstream token-validation runs)
are never auto-published.

### Manual fallback

1. Update `url` and `sha256` in `Formula/arx.rb` and open a pull request:

   ```bash
   curl -fsSL "https://github.com/eric-tramel/arx/archive/refs/tags/vX.Y.Z.tar.gz" | shasum -a 256
   ```

2. Once `brew test-bot` is green, run the **brew pr-pull** workflow
   (Actions tab) with the PR number to publish bottles and merge.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

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

## Updating a formula for a new release

1. Tag a release in the upstream repository (e.g. `v0.2.0`).
2. Compute the source tarball checksum:

   ```bash
   curl -fsSL "https://github.com/eric-tramel/arx/archive/refs/tags/v0.2.0.tar.gz" | shasum -a 256
   ```

3. Update `url` and `sha256` in `Formula/arx.rb` and open a pull request.
4. Once `brew test-bot` is green on the PR, run the **brew pr-pull** workflow
   (Actions tab) with the PR number to publish bottles and merge.

The upstream [`arx` release workflow](https://github.com/eric-tramel/arx/blob/main/.github/workflows/release.yml)
automates steps 2–3 when its `TAP_BUMP_TOKEN` secret is configured.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

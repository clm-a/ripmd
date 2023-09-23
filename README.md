# 🪦 Ripmd

Document-oriented outputs for [Livebook](https://github.com/livebook-dev/livebook) (v0.10.0) notebooks.

While there's still no built-in support to render plain html in Livebook, Ripmd is a very early stage command line tool to convert rich outputs to plain, readable, document-oriented outputs (by dropping client-server Kino's JS Live interactions).

Use case : sharing data-scientistic work generated from Livebook in portable plain static files.

🧨 *This tool is intended be deleted as soon as a smarter solution is added to Livebook :) [This issue](https://github.com/livebook-dev/livebook/issues/1159) drives the way to go (which was, to some degree, an initial intention for me).*

## Demo

| Source | Live notebook | Ripmd rendered HTML |
:-------:|:-------------:|:--------------------:
![source](https://github.com/clm-a/ripmd/assets/281692/668ba75f-e5b1-4da5-b223-5b926d5aae35) | ![livebook](https://github.com/clm-a/ripmd/assets/281692/d4998cdf-7554-4189-bd0c-96a1a90a51e9) |  ![ripmd](https://github.com/clm-a/ripmd/assets/281692/a8f52a46-b443-4f48-8713-c81d3fe1d6da)

## Usage

### 0. Install the CLI

```bash
# from this repo
MIX_ENV=prod mix escript.install github clm-a/ripmd

# or build it locally after customization
MIX_ENV=prod mix do escript.build, escript.install
```

### 1. Download your notebook livemd file

(without persisted outputs)

### 2. Edit your notebook.

Within your offline downloaded notebook, add `kino_ripmd` at the end of the deps of your setup section :

```elixir
Mix.install([
  ...deps...,
  {:kino_ripmd, github: "clm-a/kino_ripmd"}
])
```

NB: `ripmd` is the Livebook driver/CLI, while `kino_ripmd` overrides interactive elements on notebook cells evaluation.

### 3. Run the CLI

```bash
ripmd myfile.livemd output.html
```

You can also run it within `iex -S mix` in order to test your customizations

```elixir
Ripmd.livemd_to_html("example.livemd", "output.html")
```

## Troubleshooting and known issues

- If it hangs with `[info] Waiting for cells : ["3blsbkepd5hd5aw6ccuclhhkokmypr3z"]`, it's probably because a cell evaluation failed. Failure management is yet to be implemented.

## What's the hack ?

`ripmd` drives a whole Livebook app instance as a backend to render your LiveMarkdown file, while `kino_ripmd` redefines Kino's render implementations to generate static outputs.

Some `config.exs` have been edited such as `config :livebook, :serverless, true` to avoid starting the Livebook web endpoint.

## Limitations

- There is no interface to manage Hubs
- You cant't manage secrets natively yet (hardcode them in the cell once you have downloaded the notebook, then clean the generated html output)
- It has been designed against the default `ElixirStandalone` runtime
- SmartCells and interactive inputs are not supported (and may crash rendering)

Ripmd currently only renders these rich outputs :
- Markdown
- VegaLite charts (still client-side interactive)
- Kino.DataTable

## Sidenote

It's very interesting to hack Livebook! As this project is pretty naive, maybe it's worth a look if you are interested in discovering some of the Livebook internals.

Any feedback would be very appreciated, don't hesitate to open an issue.

## TODO

Renderers

- [ ] Explorer's DataFrames
- [ ] ...?

Features

- [ ] Handle and inform cell evaluation failure
- [ ] Continue rendering ohter cells on evaluation failure
- [ ] Secrets management
- [ ] Option to render VegaLite as inline PNGs
- [ ] Bring the feature to Livebook itself 🙏 and forget about this cranky project

## PROBABLY WON'T BE DONE

- Tests
- Hubs management
- Runtimes compatibility other than `ElixirStandalone`

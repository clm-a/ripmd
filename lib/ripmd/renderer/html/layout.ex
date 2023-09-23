defmodule Ripmd.Renderer.HTML.Layout do
  use Phoenix.Component
  import Ripmd.Renderer.HTML.{NotebookComponents, Stylesheet}

  embed_templates("layout.html")
end

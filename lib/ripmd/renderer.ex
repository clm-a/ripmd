defmodule Ripmd.Renderer do
  defdelegate render_html(notebook), to: Ripmd.Renderer.HTML, as: :render
end

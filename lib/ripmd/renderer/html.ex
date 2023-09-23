defmodule Ripmd.Renderer.HTML do
  def render(notebook) do
    Phoenix.Template.render_to_string(Ripmd.Renderer.HTML.Layout, "layout", "html", %{
      notebook: notebook
    })
  end
end

defmodule Ripmd.Renderer.HTML.NotebookComponents do
  use Phoenix.Component
  import Phoenix.HTML

  def section(assigns) do
    ~H"""
    <h2><%= @section.name %></h2>
    <.cell :for={cell <- @section.cells} cell={cell} />
    """
  end

  def cell(%{cell: %Livebook.Notebook.Cell.Markdown{}} = assigns) do
    ~H"""
    <%= raw Earmark.as_html!(@cell.source) %>
    """
  end

  def cell(%{cell: %Livebook.Notebook.Cell.Code{}} = assigns) do
    ~H"""
    <div style="border-left: 1px solid #ccc;padding-left: 8px; margin-bottom: 14px;">
      <.cell_source cell={@cell} />
      <.cell_outputs cell={@cell} />
    </div>

    """
  end

  defp cell_source(assigns) do
    ~H"""
    <details>
      <summary>show source</summary>
      <%= raw Makeup.highlight(@cell.source) %>
    </details>
    """
  end

  defp cell_outputs(assigns) do
    ~H"""
    <%= for {_, {type, output}} = cell <- @cell.outputs, type == :text do %>
      <.cell_output type={type} output={output} cell={cell} />
    <% end %>
    <%= for {_, {type, output}} = cell <- @cell.outputs, type == :stdout do %>
      <.cell_output type={type} output={output} cell={cell} />
    <% end %>
    <%= for {_, output} <- @cell.outputs, is_binary(output) do %>
      <.cell_output type={:rich} output={output} />
    <% end %>
    """
  end

  defp cell_output(%{type: :text} = assigns) do
    ~H"""
    <details>
    <summary>show stdout</summary>
      <%= AnsiToHTML.generate_phoenix_html(@output, ansi_theme()) %>
    </details>
    """
  end

  defp cell_output(%{type: :stdout} = assigns) do
    ~H"""
    <details>
    <summary>show stdout</summary>
      <%= raw Makeup.highlight(@output) %>
    </details>
    """
  end

  defp cell_output(%{type: :rich} = assigns) do
    ~H"""
    <div>
      <%= raw(@output) %>
    </div>
    """
  end

  defp ansi_theme() do
    %AnsiToHTML.Theme{
      name: "Ripmd Theme",
      container:
        {:pre,
         [
           style: "font-family: monospace; font-size: 12px; padding: 4px; color: charcoal;"
         ]},
      "\e[1m": {:strong, []},
      "\e[3m": {:i, []},
      "\e[4m": {:span, [style: "text-decoration: underline;"]},
      "\e[9m": {:span, [style: "text-decoration: line-through;"]},
      "\e[30m": {:span, [style: "color: black;"]},
      "\e[31m": {:span, [style: "color: red;"]},
      "\e[32m": {:span, [style: "color: green;"]},
      "\e[33m": {:span, [style: "color: yellow;"]},
      "\e[34m": {:span, [style: "color: blue;"]},
      "\e[35m": {:span, [style: "color: magenta;"]},
      "\e[36m": {:span, [style: "color: cyan;"]},
      "\e[37m": {:span, [style: "color: white;"]},
      # default to the text color in browser
      "\e[39m": {:text, []},
      "\e[40m": {:span, [style: "background-color: black;"]},
      "\e[41m": {:span, [style: "background-color: red;"]},
      "\e[42m": {:span, [style: "background-color: green;"]},
      "\e[43m": {:span, [style: "background-color: yellow;"]},
      "\e[44m": {:span, [style: "background-color: blue;"]},
      "\e[45m": {:span, [style: "background-color: magenta;"]},
      "\e[46m": {:span, [style: "background-color: cyan;"]},
      "\e[47m": {:span, [style: "background-color: white;"]},
      "\e[49m": {:span, [style: "background-color: black;"]}
    }
  end
end

defmodule Ripmd do
  @verbose true

  alias Livebook.{Session, Sessions, Runtime, FileSystem, LiveMarkdown}
  alias Ripmd.Renderer

  require Logger

  def livemd_to_html(input_path, output_path, _opts \\ [])
      when not is_nil(output_path) do
    Logger.info("Starting session for rendering #{input_path} to #{output_path}")
    {:ok, {notebook, file}} = notebook_from_local_path(input_path)
    {:ok, {session, runtime}} = setup_session_for_notebook_and_file!(notebook, file)

    Logger.info("Running full evaluation")
    session_data = Session.get_data(session.pid)

    full_evaluation_task =
      run_full_evaluation_task(
        session,
        Session.Data.cell_ids_for_full_evaluation(session_data, [])
      )

    Task.await(full_evaluation_task, :infinity)
    Logger.info("Render complete")

    notebook = Session.get_notebook(session.pid)

    Runtime.disconnect(runtime)
    Session.close(session.pid)

    output_path = Path.expand("#{File.cwd!()}/#{output_path}")

    notebook
    |> Renderer.render_html()
    |> then(fn html ->
      Logger.info("Writing HTML to #{output_path}")
      File.write!(output_path, html)
    end)
  end

  def notebook_from_local_path(path) do
    with file <- FileSystem.File.local(Path.expand("#{File.cwd!()}/#{path}")),
         {notebook, _messages} <- LiveMarkdown.notebook_from_livemd(File.read!(file.path)),
         notebook <- Map.put(notebook, :autosave_interval_s, nil) do
      {:ok, {notebook, file}}
    end
  end

  defp setup_session_for_notebook_and_file!(notebook, file) do
    with {:ok, session} <-
           Sessions.create_session(
             notebook: notebook,
             file: file,
             origin: {:file, file}
           ),
         session_data <- Session.get_data(session.pid),
         {:ok, runtime} <- Runtime.connect(session_data.runtime) do
      Runtime.take_ownership(runtime)
      {:ok, {session, runtime}}
    end
  end

  defp run_full_evaluation_task(session, cell_ids) do
    task =
      Task.async(fn ->
        Session.subscribe(session.id)
        Logger.info("Waiting for renderings...")
        wait(cell_ids)
      end)

    Session.queue_full_evaluation(session.pid, [])
    task
  end

  defp wait([]), do: :done

  defp wait(cells) do
    Logger.info("Waiting for cells : #{inspect(cells)}")

    receive do
      {:operation, {:add_cell_evaluation_response, "__server__", cell_id, _, _}} ->
        wait(List.delete(cells, cell_id))

      any ->
        if @verbose, do: Logger.info(inspect(any))
        wait(cells)
    end
  end
end

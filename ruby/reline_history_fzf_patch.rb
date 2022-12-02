module RelineHistoryFzfPatch
  private def incremental_search_history(_)
    history = Reline::HISTORY.reverse
      .uniq
      .map { IRB::Color.colorize_code(_1, ignore_error: true) }
      .join("\0")

    stdin_read, stdin_write = IO.pipe
    stdout_read, stdout_write = IO.pipe

    stdin_write.write(history)
    stdin_write.sync = true
    stdin_write.close

    fzf_command = "fzf --no-info --no-sort --no-multi --ansi --read0 --scheme=history"
    pid = spawn(fzf_command, in: stdin_read, out: stdout_write)
    stdout_write.close
    Process.wait(pid)

    result = stdout_read.read
    [stdin_read, stdin_write, stdout_read, stdout_write].each(&:close)

    # If you would like an easy life, do this instead
    # require "open3"
    # result, _status = Open3.capture2(fzf_command, stdin_data: history)

    @line_backup_in_history = whole_buffer
    @buffer_of_lines        = result.split("\n")
    @line_index             = @buffer_of_lines.size - 1
    @line                   = @buffer_of_lines.last
    @cursor                 = @cursor_max = calculate_width(@line)
    @byte_pointer           = @line.bytesize
    @rerender_all           = true
  end
end

# Use FZF for history search
require "reline"
Reline::LineEditor.prepend(RelineHistoryFzfPatch)

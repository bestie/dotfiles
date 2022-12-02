module RelineHistoryFzfPatch
  private def incremental_search_history(_)
    history = Reline::HISTORY.reverse
                             .uniq
                             .map { IRB::Color.colorize_code(_1, ignore_error: true) }
                             .join("\0")

    file = Tempfile.new
    file.write(history)
    file.close

    result = `fzf --no-info --no-sort --no-multi --ansi --read0 --scheme=history < #{file.path}`

    @line_backup_in_history = whole_buffer
    @buffer_of_lines        = result.split("\n")
    @line_index             = @buffer_of_lines.size - 1
    @line                   = @buffer_of_lines.last
    @cursor                 = @cursor_max = calculate_width(@line)
    @byte_pointer           = @line.bytesize
    @rerender_all           = true
  ensure
    file.unlink
  end
end

# Use FZF for history search
require "reline"
Reline::LineEditor.prepend(RelineHistoryFzfPatch)

module GoodIRBHelperMethods
  # q to exit like less
  def q
    exit 1
  end

  def _good_caller
    caller.grep_v(/pry|byebug/)
  end

  def _good_caller_just_this_project
    project_dir = File.expand_path(".")
    caller.grep(project_dir)
  end

  def _good_locals_hash(their_binding)
    local_names = their_binding.local_variables
    local_names.map { |n|
      [n, their_binding.local_variable_get(n)]
    }.to_h
  end

  def _good_args(their_binding)
    param_names = trace.parameters.map(&:last)
    param_names.map { |n| [n, their_binding.eval(n.to_s)] }.to_h
  end
end

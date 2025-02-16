module ApplicationHelper
  def dashboard_path_for_current_user
    if defined?(current_user) && current_user
      dashboard_path
    elsif defined?(current_expert) && current_expert
      expert_dashboard_path
    else
      root_path
    end
  end

  def current_dashboard_active?
    if defined?(current_user) && current_user
      current_page?(dashboard_path)
    elsif defined?(current_expert) && current_expert
      current_page?(expert_dashboard_path)
    else
      false
    end
  end
end

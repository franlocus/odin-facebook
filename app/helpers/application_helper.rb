module ApplicationHelper
  include Pagy::Frontend

  def active_class?(class_name = nil, path)
    class_name ||= ""
    class_name += " active" if current_page?(path)
    class_name.strip!
    return class_name
  end
end

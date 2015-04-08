module ApplicationHelper
  def bootstrap_class_for(flash_type)
    case flash_type
    when 'success' then 'alert-success'
    when 'notice' then 'alert-info'
    when 'alert' then 'alert-warning'
    when 'error' then 'alert-danger'
    else; flash_type.to_s
    end
  end
end

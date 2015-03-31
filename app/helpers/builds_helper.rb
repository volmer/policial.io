module BuildsHelper
  def state_label(build)
    label_class = "label label-#{bs_context(build)}"
    content_tag(:span, build.state, class: label_class)
  end

  def bs_context(build)
    case build.state
    when 'pending'
      'warning'
    when 'success'
      'success'
    when 'failure'
      'danger'
    else
      'default'
    end
  end

  def link_to_line(violation)
    repo = violation.build.repo
    sha = violation.build.sha
    url = "https://github.com/#{repo}/blob/#{sha}/#{violation.filename}"\
          "#L#{violation.line_number}"
    text = "#{violation.filename}:#{violation.line_number}"

    link_to(text, url, target: '_blank')
  end
end

module ApplicationHelper
  ICONS_PATH = Rails.root.join("app/assets/images/icons")

  # Navbar link classes, adding the active state when the given path (or controller) matches the current request.
  def nav_link_classes(path, controller: nil)
    active = controller ? controller_name == controller : current_page?(path)
    class_names("nav-link", "nav-link--active" => active)
  end

  # Inline Font Awesome Free SVG (CC BY 4.0) from app/assets/images/icons, tinted with currentColor.
  def icon(name, class: "inline-block w-[1em] h-[1em] align-[-0.125em]", title: nil)
    svg = File.read(ICONS_PATH.join("#{name}.svg"))
    attrs = %(class="#{binding.local_variable_get(:class)}" fill="currentColor" )
    attrs += title ? %(role="img" aria-label="#{ERB::Util.html_escape(title)}" ) : %(aria-hidden="true" )
    svg.sub("<svg ", "<svg #{attrs}").html_safe
  end

  # Renders Markdown to HTML. Raw HTML in the source is dropped (commonmarker's default), so the output is safe.
  def markdown(text)
    Commonmarker.to_html(
      text.to_s,
      options: { render: { hardbreaks: false }, extension: { header_ids: nil } },
      plugins: { syntax_highlighter: nil }
    ).html_safe
  end
end

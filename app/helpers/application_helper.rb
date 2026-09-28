module ApplicationHelper
  ICONS_PATH = Rails.root.join("app/assets/images/icons")

  # Inline Font Awesome Free SVG (CC BY 4.0) from app/assets/images/icons, tinted with currentColor.
  def icon(name, class: "inline-block w-[1em] h-[1em] align-[-0.125em]", title: nil)
    svg = File.read(ICONS_PATH.join("#{name}.svg"))
    attrs = %(class="#{binding.local_variable_get(:class)}" fill="currentColor" )
    attrs += title ? %(role="img" aria-label="#{ERB::Util.html_escape(title)}" ) : %(aria-hidden="true" )
    svg.sub("<svg ", "<svg #{attrs}").html_safe
  end
end

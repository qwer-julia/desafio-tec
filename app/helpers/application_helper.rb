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

  # The user's mascot: stacked transparent layers (base, costume, accessories) sharing one canvas.
  def avatar(user = nil, layers: nil, class: "w-20", **attrs)
    layers ||= user ? user.avatar_layers : Avatar.layers(costume: nil, accessories: [])
    images = layers.map { |name| image_tag("/avatar/#{name}.png", alt: "", class: "absolute inset-0 w-full h-full", data: { layer: name }) }
    tag.div(safe_join(images), class: [ "relative aspect-[1600/2458] shrink-0", binding.local_variable_get(:class) ], **attrs)
  end

  # Just the face of the user's mascot, cropped from the full-size layers, for use as a round icon.
  FACE_CROP = { x: 395, y: 565, size: 710 }.freeze
  CANVAS_WIDTH = 1600

  def avatar_face(user, class: "w-12 h-12")
    crop = FACE_CROP
    stage = tag.div(
      safe_join(user.avatar_layers.map { |name| image_tag("/avatar/#{name}.png", alt: "", class: "absolute inset-0 w-full h-full") }),
      class: "absolute aspect-[1600/2458]",
      style: "width: #{(CANVAS_WIDTH * 100.0 / crop[:size]).round(2)}%; left: #{(-crop[:x] * 100.0 / crop[:size]).round(2)}%; top: #{(-crop[:y] * 100.0 / crop[:size]).round(2)}%;"
    )
    tag.span(tag.span(stage, class: "absolute inset-0 overflow-hidden rounded-full bg-white"), class: [ "avatar-face relative inline-block shrink-0", binding.local_variable_get(:class) ], aria: { hidden: true })
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

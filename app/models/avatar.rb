# The customizable mascot: neutro.png as base, at most one costume, any number of accessories.
# All layers are 1600x2458 transparent PNGs in public/avatar, so stacking them aligns them.
# Accessories are always drawn above the costume.
module Avatar
  BASE = "neutro".freeze
  COSTUMES = {
    "astronauta" => "Astronauta",
    "cowboy" => "Cowboy",
    "cozinheiro" => "Cozinheiro",
    "jason" => "Jason",
    "mago" => "Mago",
    "nerd" => "Nerd",
    "palhaco" => "Palhaço",
    "piloto" => "Piloto"
  }.freeze
  ACCESSORIES = {
    "oculos_grau" => "Óculos de grau",
    "oculos_sol" => "Óculos de sol",
    "bigode" => "Bigode",
    "cigarro" => "Cigarro"
  }.freeze

  # Image file names (without extension) for a user, bottom to top.
  def self.layers(costume:, accessories:)
    [ BASE, (costume.presence && "fantasia_#{costume}"), *ACCESSORIES.keys.select { |key| accessories.include?(key) } ].compact
  end
end

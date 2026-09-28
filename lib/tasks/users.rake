namespace :users do
  desc "Create or promote an admin user. Requires ADMIN_EMAIL and ADMIN_PASSWORD env vars; ADMIN_NAME is optional."
  task create_admin: :environment do
    email = ENV.fetch("ADMIN_EMAIL")
    password = ENV.fetch("ADMIN_PASSWORD")
    name = ENV.fetch("ADMIN_NAME", "Admin")

    user = User.find_or_initialize_by(email_address: email.strip.downcase)
    user.name = name if user.name.blank?
    user.password = password
    user.admin = true
    user.confirmed_at ||= Time.current
    user.save!

    puts "#{user.previously_new_record? ? "Created" : "Updated"} admin user: #{user.email_address}"
  end
end

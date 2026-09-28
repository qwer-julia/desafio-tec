namespace :db do
  desc "Load the schema for the cache/cable databases when db:prepare skips them " \
       "because they share the primary's physical database (see render.yaml)"
  task prepare_shared: :environment do
    sentinel_tables = {
      "cache" => "solid_cache_entries",
      "cable" => "solid_cable_messages"
    }

    sentinel_tables.each do |name, sentinel_table|
      db_config = ActiveRecord::Base.configurations.configs_for(env_name: Rails.env, name: name)
      next unless db_config

      ActiveRecord::Base.establish_connection(db_config)
      next if ActiveRecord::Base.connection.table_exists?(sentinel_table)

      puts "Loading schema for the '#{name}' database (#{sentinel_table} is missing)..."
      ActiveRecord::Tasks::DatabaseTasks.load_schema(db_config, db_config.schema_format)
    end
  ensure
    ActiveRecord::Base.establish_connection(:primary)
  end
end

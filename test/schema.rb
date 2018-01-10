ActiveRecord::Schema.define(:version => 1) do

  create_table :abstract_posts do |t|
    t.hstore :title
    t.hstore :body
    t.jsonb :summary
    t.string :name
  end

end

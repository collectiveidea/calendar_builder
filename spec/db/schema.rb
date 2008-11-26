ActiveRecord::Schema.define(:version => 0) do

  create_table :events, :force => true do |t|
    t.column :name, :string
    t.column :begin_at, :datetime
    t.column :end_at, :datetime
  end
  
  create_table :games, :force => true do |t|
    t.column :name, :string
    t.column :start_time, :datetime
    t.column :end_time, :datetime
  end

  # Events with scoping

  create_table :communities, :force => true do |t|
    t.column :name, :string
  end

  create_table :parties, :force => true do |t|
    t.column :community_id, :integer, :null => false
    t.column :begin_at, :datetime
    t.column :end_at, :datetime
  end

end

class CreateCategories < ActiveRecord::Migration
  def self.up
    # create categories table
    create_table :categories do |t|
      t.integer :account_id
      t.integer :parent_id
      t.string  :name

      t.timestamps
    end
    add_index :categories, :account_id
    add_index :categories, :parent_id

    # create categories_domains join table
    create_table :categories_domains, :id => false do |t|
      t.integer :category_id
      t.integer :domain_id
    end
    add_index :categories_domains, :category_id
    add_index :categories_domains, :domain_id
  end

  def self.down
    # drop categories_domains join table
    remove_index :categories_domains, :domain_id
    remove_index :categories_domains, :category_id
    drop_table :categories_domains

    # drop categories table
    remove_index :categories, :parent_id
    remove_index :categories, :account_id
    drop_table :categories
  end
end

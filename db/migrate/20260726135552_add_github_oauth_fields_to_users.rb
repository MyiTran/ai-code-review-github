class AddGithubOauthFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :github_username, :string
    add_column :users, :avatar_url, :string
    add_column :users, :github_access_token, :text
    add_column :users, :role, :integer, null: false, default: 0

    add_index :users,
              %i[provider uid],
              unique: true,
              where: "provider IS NOT NULL AND uid IS NOT NULL"
  end
end
defmodule Mentions.Repo.Migrations.AddMigrationsTable do
  use Ecto.Migration

  def change do
    create table "mentions" do
      add :tweet_id, :string
      add :search_for, :string
      add :user, :string
      add :text, :string
      add :created_at, :naive_datetime
      add :retweets, :integer
    end
  end
end

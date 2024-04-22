defmodule Sneakers23.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :sku, :string, null: false
      add :size, :string, null: false
      add :product_id, references(:products, on_delete: :nothing), null: false

      timestamps(null: false)
    end

    create index(:items, [:product_id])
    create unique_index(:items, [:sku])
  end
end

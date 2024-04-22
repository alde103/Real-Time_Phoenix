defmodule Sneakers23.Repo.Migrations.CreateItemAvailabilities do
  use Ecto.Migration

  def change do
    create table(:item_availabilities) do
      add :available_count, :integer, null: false
      add :item_id, references(:items, on_delete: :nothing), null: false

      timestamps(null: false)
    end

    create index(:item_availabilities, [:item_id])
  end
end

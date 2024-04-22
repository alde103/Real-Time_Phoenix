defmodule Sneakers23.Inventory.ItemAvailability do
  use Ecto.Schema
  import Ecto.Changeset

  schema "item_availabilities" do
    field :available_count, :integer
    belongs_to :item, Sneakers23.Inventory.Item

    timestamps()
  end

  @doc false
  def changeset(item_availability, attrs) do
    item_availability
    |> cast(attrs, [:available_count, :item_id])
    |> validate_required([:available_count, :item_id])
  end
end

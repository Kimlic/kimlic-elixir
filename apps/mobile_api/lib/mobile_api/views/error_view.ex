defmodule MobileApi.ErrorView do
  @moduledoc false

  use MobileApi, :view

  @spec render(binary, map) :: map
  def render("500.json", _assigns) do
    %{errors: %{detail: "Internal Server Error"}}
  end

  def render("401.json", _assigns) do
    %{errors: %{detail: "Unauthorized"}}
  end

  @spec template_not_found(binary, map) :: map
  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end
end

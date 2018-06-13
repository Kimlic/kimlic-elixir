defmodule MobileApi.VerificationVideoControllerTest do
  @moduledoc false

  use MobileApi.ConnCase, async: true

  @moduletag :authorized

  describe "get video verification vendors" do
    test "success", %{conn: conn} do
      assert %{"data" => %{"vendors" => [%{"id" => _, "description" => _, "documents" => _} | _]}} =
               conn
               |> get(verification_video_path(conn, :get_vendors))
               |> json_response(200)
    end
  end
end

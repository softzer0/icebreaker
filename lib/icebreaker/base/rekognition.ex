defmodule Icebreaker.Base.Rekognition do
  alias Icebreaker.Accounts

  @collection_id "icebreaker"

  def search_or_index_face(user, img_data) do
    @collection_id
    |> ExAws.Rekognition.search_faces_by_image(img_data, max_faces: 1)
    |> ExAws.request()
    |> handle_response(img_data)
    |> upload_selfie(user, img_data)
  end

  defp handle_response({:ok, %{"FaceMatches" => []}}, img_data) do
    @collection_id
    |> ExAws.Rekognition.index_faces(img_data, max_faces: 1)
    |> ExAws.request()
    |> handle_response()
  end

  defp handle_response({:ok, %{"FaceMatches" => matches}}, _), do: matches
  defp handle_response({:ok, %{"FaceRecords" => matches}}), do: matches

  defp upload_selfie(matches, user, img_data) do
    face_id = matches |> List.first() |> Map.get("Face") |> Map.get("FaceId")
    Accounts.update_user(user, %{face_id: face_id})
    selfie_id = UUID.uuid4()

    ExAws.S3.put_object(
      Application.get_env(:ex_aws, :config)[:bucket_name],
      "#{selfie_id}.jpg",
      img_data
    )
    |> ExAws.request()

    Accounts.update_user(user, %{last_selfie_id: selfie_id, exceeded_range: false})
  end
end

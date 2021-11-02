defmodule Icebreaker.Base.Sms do
  @phone Application.fetch_env!(:ex_twilio, :phone_number)

  def send_token(phone, token) do
    body = "Icebreaker: Your verification code is #{token}"

    send_sms(phone, body)
  end

  def send_sms(target, body) do
    ExTwilio.Message.create(to: target, from: @phone, body: body)
  end
end

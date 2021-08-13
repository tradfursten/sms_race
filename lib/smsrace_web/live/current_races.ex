defmodule SmsraceWeb.CurrentRacesLive do
  use SmsraceWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end


  def render(assigns) do
    ~L"""
      <h1 class="text-2xl p-4">Current races</h1>
      <ul>
        <li><%= live_redirect "Marsliden Seven Summits", to: Routes.live_path(@socket, SmsraceWeb.RaceLive, 2), class: "text-blue-400 underline" %></li>
        <li><%= live_redirect "Marsliden Three Summits", to: Routes.live_path(@socket, SmsraceWeb.RaceLive, 3), class: "text-blue-400 underline" %></li>
      </ul>
    """
  end
end

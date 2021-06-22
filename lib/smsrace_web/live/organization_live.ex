defmodule SmsraceWeb.OrganizationLive do
  use SmsraceWeb, :live_view


  def mount(_params, session, socket) do

    socket = if connected?(socket) do
      user = Smsrace.Accounts.get_user_by_session_token(session["user_token"])
      case user do
        {:ok, %{organization_id: orgid} = user} ->
          case orgid do
            nil ->
              assign(socket, section: :new_organization, user_id: user.id)
            _ ->
              assign(socket, section: :edit_organization, user_id: user.id)
          end
         _ ->
          assign(socket, section: :new_organization, user_id: user.id)
      end
    else
      assign(socket, section: :new_organization)
    end
    {:ok, socket}
  end

  def handle_event("create_organization", %{"name" => name, "emergency" => emergency, "incomming" => incomming}, socket) do
    {:ok, organization} = Smsrace.Accounts.create_organization(%{name: name, number: incomming, emergency: emergency})
    IO.inspect(organization)
    Smsrace.Accounts.add_user_to_organization(socket.assigns.user_id, organization.id)
    {:noreply, push_redirect(socket, to: "/")}
  end

end

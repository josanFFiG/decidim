# frozen_string_literal: true

require "spec_helper"

shared_examples "Managing feature permissions" do
  let(:organization) { create(:organization, available_authorizations: ["Decidim::DummyAuthorizationHandler"]) }
  let(:user) { create(:user, :admin, :confirmed, organization: organization) }

  let!(:feature) do
    create(:feature, participatory_space: participatory_space)
  end

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit participatory_space_engine.features_path(participatory_space)

    within ".feature-#{feature.id}" do
      page.find(".action-icon--permissions").click
    end
  end

  it "allows setting permissions with json options" do
    within "form.new_feature_permissions" do
      within ".foo-permission" do
        select "Example authorization", from: "feature_permissions_permissions_foo_authorization_handler_name"
        fill_in "feature_permissions_permissions_foo_options", with: '{ "foo": 123 }'
      end
      find("*[type=submit]").click
    end

    expect(page).to have_content("successfully")

    expect(feature.reload.permissions["foo"]).to(
      include(
        "authorization_handler_name" => "decidim/dummy_authorization_handler",
        "options" => { "foo" => 123 }
      )
    )
  end
end

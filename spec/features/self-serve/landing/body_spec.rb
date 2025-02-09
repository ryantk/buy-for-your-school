RSpec.feature "Users can see a start page" do
  before do
    visit "/"
  end

  context "when user is not signed in" do
    it "has a start button to login and redirects user to login page after clicking it" do
      within "main.govuk-main-wrapper" do
        expect(find("form.button_to")["action"]).to eql "/auth/dfe"
        # generic.button.start
        expect(page).to have_button "Start now", class: "govuk-button govuk-!-margin-top-2 govuk-!-margin-bottom-8 govuk-button--start"
      end
    end
  end

  context "when user already signed in" do
    before do
      user_exists_in_dfe_sign_in

      # landing page
      visit "/"
    end

    it "has a start button and redirects user to dashboard after clicking it" do
      within "main.govuk-main-wrapper" do
        # generic.button.start
        expect(page).to have_button "Start now", class: "govuk-button govuk-!-margin-top-2 govuk-!-margin-bottom-8 govuk-button--start"
      end
      click_start
      expect(page).to have_current_path "/dashboard"
    end
  end

  it "has a heading" do
    expect(find("h1.govuk-heading-xl")).to have_text "Create a specification to procure for your school"
  end

  it "has the right content headers" do
    expect(page).to have_xpath("//meta[@name=\"robots\" and contains(@content, \"noindex,nofollow\")]", visible: :hidden)
  end

  # Who this service is for
  # How this service works
  scenario do
    # specifying.start_page.overview_purpose
    expect(all("p.govuk-body")[0]).to have_text "Use this service to create a specification for either:"
    within(all("ul.govuk-list.govuk-list--bullet")[0]) do
      # specifying.start_page.overview_supported_category_list
      expect(page).to have_text "a catering service, or multi-functional devices"
    end

    # specifying.start_page.overview_download
    expect(all("p.govuk-body")[1]).to have_text "You will be able to download the specification that you create and share it with suppliers when you invite them to bid."

    # specifying.start_page.who_can_use_body
    expect(all("p.govuk-body")[2]).to have_text "You can use this service if you:"
    within(all("ul.govuk-list.govuk-list--bullet")[1]) do
      # specifying.start_page.who_can_use_list
      expect(page).to have_text "are procuring for a single school in England - either a local authority maintained school or an academy in a single or multi-academy trust are procuring a single contract"
    end

    # specifying.start_page.before_you_start_title
    expect(all("h2.govuk-heading-m")[0]).to have_text "Before you start"
    # specifying.start_page.before_you_start_body[0]
    expect(all("p.govuk-body")[3]).to have_text "The service will guide you through what information to provide. Standard regulations and requirements that suppliers must comply with will be added automatically."
    # specifying.start_page.before_you_start_body[1]
    expect(all("p.govuk-body")[4]).to have_text "You can save your specification and come back to it later if you want."
  end
end

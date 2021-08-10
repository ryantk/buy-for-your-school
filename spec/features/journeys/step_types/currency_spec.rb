RSpec.feature "currency" do
  let(:user) { create(:user) }
  let(:fixture) { "currency-question.json" }

  before do
    user_is_signed_in(user: user)
    # TODO: setup with factory
    start_journey_from_category(category: fixture)
    click_first_link_in_section_list
  end

  context "when the step is of type currency" do
    scenario "user can answer using a currency number input" do
      fill_in "answer[response]", with: "1,000.01"
      click_continue

      click_first_link_in_section_list

      # /journeys/302e58f4-01b3-469a-906e-db6991184699/steps/46005bbe-1aa2-49bf-b0df-0f027522f50d/edit
      expect(page).to have_an_edit_step_path
      expect(find_field("answer-response-field").value).to eql("1000.01")
    end

    scenario "throws error when non numerical values are entered" do
      fill_in "answer[response]", with: "one hundred pounds"
      click_continue

      # /journeys/302e58f4-01b3-469a-906e-db6991184699/steps/46005bbe-1aa2-49bf-b0df-0f027522f50d/answers
      expect(page).to have_an_answer_path
      expect(page).to have_content("does not accept £ signs or other non numerical characters")
    end
  end
end

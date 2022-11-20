require "test_helper"

class CompanyControllerTest < ActionDispatch::IntegrationTest
  test "root is reachable and leads to the company list" do
    visit('/')
    assert_text("Companies")
  end

  test "company details has like button that increases with clicks on like button, and disables after click" do
    visit('/')
    find(:xpath, "/html/body/div[2]/ul/li[1]/details/summary").click
    within_frame '13243848' do
      assert_text("Likes: 0")
      find(:xpath, "/html/body/div/form/input[2]").click
      sleep 2
      assert_text("Likes: 1")
      assert_text("Please wait before liking again")
    end
  end

  test "likes are global" do
    visit('/')
    Company.find_by(api_id: "13243848").update(likes: 100)
    visit('/companies')
    find(:xpath, "/html/body/div[2]/ul/li[1]/details/summary").click

    within_frame '13243848' do
      assert_text("Likes: 100")
    end
  end

end

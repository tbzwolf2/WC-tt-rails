require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  test "company is default to likes at 0" do
    new_c = Company.create
    if new_c.likes == 0
      assert true
    else
      assert false
    end
  end
end

require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "forgot_password" do
    @expected.subject = 'UserMailer#forgot_password'
    @expected.body    = read_fixture('forgot_password')
    @expected.date    = Time.now

    assert_equal @expected.encoded, UserMailer.create_forgot_password(@expected.date).encoded
  end

end

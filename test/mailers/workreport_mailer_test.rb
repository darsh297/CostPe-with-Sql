require "test_helper"

class WorkreportMailerTest < ActionMailer::TestCase
  test "created" do
    mail = WorkreportMailer.created
    assert_equal "Created", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["support@costpe.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end

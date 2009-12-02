require File.expand_path(File.join(File.dirname(__FILE__), "test_bootstrap.rb"))


class PostTest < WmnizrTest
  def test_setting_password_sets_crypted_password
    @user = User.new
    assert_equal nil, @user.crypted_password
    @user.password = "foobarbaz"
    assert_not_equal nil, @user.crypted_password
  end

  def test_can_find_user_by_login_and_password
    @user = User.create(:login => 'foo', :password => 'barbaz')

    assert_equal nil, User.find_by_login_and_password('foo', 'boo')
    assert_not_equal nil, User.find_by_login_and_password('foo', 'barbaz')
  end

  def test_validate_login_is_unique
    @user = User.create(:login => 'foo', :password => 'barbaz')
    @user = User.create(:login => 'foo', :password => 'barbaz')

    assert_equal 1, User.all.count
  end
end

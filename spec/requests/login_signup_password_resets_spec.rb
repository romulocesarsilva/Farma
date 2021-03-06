require 'spec_helper'

describe "LoginSignupPasswordResets", js: true do

  describe "An unauthenticated request" do
    before do
      visit '/users/sign-in'
    end

    it "render the login, registration, and password reset form when request is to the root path" do
      assert_equal '/users/sign-in', page.current_path
      assert page.has_selector?('form#login-form')
    end

    # Logging in
    describe 'Logging in' do
      it 'show login error when login fails' do
        within('#login-form') do
          fill_in 'email', :with => 'xyz@abc.org'
          fill_in 'password', :with => 'someFunky1Password'
        end
        click_button 'Login'
        assert page.has_selector?('form#login-form div.alert-error')
      end

      it 'show logged in home page when login succeeds' do
        user = FactoryGirl.create(:user)
        within('#login-form') do
          fill_in 'email', :with => user.email
          fill_in 'password', :with => user.password
        end
        click_button 'Login'

        #assert_equal '/dashboard', page.current_path
        assert page.has_selector?('a[href="/users/sign_out"]')
      end
    end
  end

  describe 'Signing up' do
      before {visit '/'}

      it 'show logged in home page when signup succeeds'  do

        #wait_until { page.has_selector?('#sign_up_link', :visible => true) }
        click_link "sign_up_link"

        attrs = FactoryGirl.attributes_for(:user)
        within('#signup-form') do
          fill_in 'name', :with => attrs[:name]
          fill_in 'email', :with => attrs[:email]
          fill_in 'password', :with => attrs[:password]
          fill_in 'password_confirmation', :with => attrs[:password_confirmation]
        end
        click_button 'sign_up_btn'

        assert page.has_selector?('a[href="/users/sign_out"]')
     end

     it 'show an error message when signup fails' do
        click_link "sign_up_link"

        within('#signup-form') do
          fill_in 'email', :with => 'someone@example.org'
          fill_in 'password', :with => '123'
          fill_in 'password_confirmation', :with => '1234567'
        end
        click_button 'sign_up_btn'
        assert page.has_selector?('form#signup-form div.alert-error')
    end
  end

  # Password reset
  describe 'Resetting your password' do

    before {visit '/users/sign-in'}

    it 'show success message when reset submission succeeds' do
      pending("do with mock ans stup")
      user = FactoryGirl.create(:user)
      click_link 'retrieve_password'

      within('#retrieve-password-form') do
        fill_in 'email', :with => user.email
      end
      click_button 'reset_password'
      #assert page.has_selector?('form#retrieve-password-form div.alert-success')
    end

    it 'show an error message when reset fails' do
      click_link 'retrieve_password'

      within('#retrieve-password-form') do
        fill_in 'email', :with => 'someone@else.com'
      end

      click_button 'reset_password'
      assert page.has_selector?('form#retrieve-password-form div.alert-error')
    end
  end
end

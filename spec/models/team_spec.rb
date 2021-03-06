require 'spec_helper'

describe Team do

  before(:each) do
    @ids = []
    @user = FactoryGirl.create(:user, admin: false)
    @user_a = FactoryGirl.create(:user, admin: false)

    2.times do
      team = FactoryGirl.create(:team, owner_id: @user.id)
      @ids.push team.id
    end

    team = FactoryGirl.create(:team, owner_id: @user_a.id)
    team_b = FactoryGirl.create(:team, owner_id: @user_a.id)
  end

  it { should respond_to(:code) }
  it { should respond_to(:name) }
  it { should respond_to(:owner_id) }
  it { should respond_to(:available) }
  it { expect(:available).to be_true }

  it { should has_and_belongs_to_many(:los) }
  it { should has_and_belongs_to_many(:users) }
  it { should has_many(:answers) }

  it "should return owner team ids and enroll team_ids from a specific user" do
     Team.ids_by_user(@user).should eql(@ids)
  end

end

require 'spec_helper'

describe "Task pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "task creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a task" do
        expect { click_button "Post" }.not_to change(Task, :count)
      end

      describe "error messages" do
        before { click_button "Post" }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do

      before { fill_in 'task_content', with: "Lorem ipsum" }
      it "should create a task" do
        expect { click_button "Post" }.to change(Task, :count).by(1)
      end
    end
  end

  describe "task destruction" do
    before { FactoryGirl.create(:task, user: user) }

    describe "as correct user" do
      before { visit root_path }

      it "should delete a task" do
        expect { click_link "delete" }.to change(Task, :count).by(-1)
      end
    end
  end
end
require 'spec_helper'

describe RelationshipsController do
  
  describe "access control" do
    it "should require signin for create" do
      post :create
      response.should redirect_to(signin_path)
    end
    
    it "should require signin for destroy" do
      delete :destroy, :id => 1
      response.should redirect_to(signin_path)
    end
  end
  
  
  describe "POST 'create'" do
    before(:each) do
      @user = controller.sign_in(Factory(:user))
      @followed = Factory(:user, :email => Factory.next(:email))
    end
    
    it "should create a relationship" do
      lambda do
        post :create, :relationship => { :followed_id => @followed } #same as the hidden field being used on the HTML form
        response.should redirect_to(user_path(@followed))
      end.should change(Relationship, :count).by(1)
    end
    
    it "should create a relationship with AJAX" do
      lambda do
        xhr :post, :create, :relationship => { :followed_id => @followed } #xhr = xml http request 
        response.should be_success
      end.should change(Relationship, :count).by(1)
    end
  end
  
  describe "DELETE 'destroy'" do
    before(:each) do
      @user = controller.sign_in(Factory(:user))
      @followed = Factory(:user, :email => Factory.next(:email))
      @user.follow!(@followed)
      @relationship = @user.relationships.find_by_followed_id(@followed)
    end
    
    it "should destroy a relationship" do
      lambda do
        delete :destroy, :id => @relationship
        response.should redirect_to(user_path(@followed))
      end.should change(Relationship, :count).by(-1)
    end
    
    it "should destroy a relationship with AJAX" do
      lambda do
        xhr :delete, :destroy, :id => @relationship #xhr = xml http request 
        response.should be_success
      end.should change(Relationship, :count).by(-1)
    end
  end
  
end
class Admin::ApplicationBackstageController < ApplicationController
  before_action :authenticate_user!
end

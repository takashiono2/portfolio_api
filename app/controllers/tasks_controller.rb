class TasksController < ApplicationController
  def import
    Task.import(params[:file])
    redirect_to root_url
  end
end
#未使用
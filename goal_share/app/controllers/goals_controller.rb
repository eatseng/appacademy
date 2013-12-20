class GoalsController < ApplicationController
  before_filter :verify_user

  def index
    @goals = current_user.goals
  end

  def completed
    if !params[:format].nil?
      @goal = Goal.find(params[:format])
      @goal.completed!
    end
    @goals = current_user.completed_goals
  end

  def feed
    @goals = Goal.where("private == ?", false)
  end

  def cheers
    @goals = Goal.where("private == ?", false)
    if current_user.has_cheers?(current_user)
      @goal = Goal.find(params[:format])
      @cheer = current_user.cheers.new({:goal_id => @goal.id})
      if @cheer.save
        flash.now[:notice] = ["#{@goal.user.email} cheered!"]
        render :feed
      else
        flash.now[:errors] = [@cheer.errors.full_messages]
        render :feed
      end
    else
      flash.now[:errors] = ["No more cheers for today"]
      render :feed
    end
  end

  def new
    @goal = Goal.new
  end

  def create
    @goal = Goal.new(params[:goal])
    @goal.user_id = current_user.id
    if @goal.save
      flash[:notice] = ["#{@goal.body} created!"]
      redirect_to goals_url
    else
      flash.now[:errors] = [@goal.errors.full_messages]
      render :new
    end
  end

  def edit
    @goal = Goal.find(params[:id])
  end

  def update
    @goal = Goal.find(params[:id])
    if @goal.update_attributes(params[:goal])
      flash[:notice] = ["#{@goal.body} updated!"]
      redirect_to goals_url
    else
      flash.now[:errors] = [@goal.errors.full_messages]
      render :new
    end
  end

  def destroy
    @goal = Goal.find(params[:id])
    flash[:notice] = ["#{@goal.body} deleted"]
    @goal.destroy
    redirect_to goals_url
  end

end

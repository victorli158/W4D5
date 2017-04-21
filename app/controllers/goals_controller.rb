class GoalsController < ApplicationController
  def new
    @goal = Goal.new
    render :new
  end

  def edit
    @goal = Goal.find_by(id: params[:id])
    if @goal
      render :edit
    else
      redirect_to user_url(current_user)
    end
  end

  def create
    new_goal_params = goal_params.merge(user_id: params[:user_id])
    @goal = Goal.new(new_goal_params)
    flash[:errors] = @goal.errors.full_messages unless @goal.save

  end

  def update
    @goal = Goal.find_by(id: params[:id])
    redirect_to user_url(current_user) unless @goal
    unless @goal.update_attributes(goal_params)
      flash[:errors] = @goal.errors.full_messages
    end

    redirect_to user_url(current_user)
  end

  def destroy
    @goal = Goal.find_by(id: params[:id])
    if @goal
      @goal.destroy
    else
      flash[:errors] = ['Attempted to delete nonexistant goal.']
    end
    redirect_to user_url(current_user)
  end

  private

  def goal_params
    params.require(:goal).permit(:title,
                                 :description,
                                 :target_date,
                                 :public_goal)
  end
end

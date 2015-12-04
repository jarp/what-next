class StoryController < ActiveUsersController

  def index
    # puts session[:subscribed_stories].inspect
    # puts session[:current_story_id].inspect

    if session[:current_story_id]
      set_current_story
    elsif session[:subscribed_stories].nil?
      flash[:message] = "you have not subscribed to any stories yet"
      redirect_to account_path
    else
      redirect_to choose_story_path
    end
  end


  def choose
    @subscriptions = active_user.subscriptions.decorate.select { | sub | !sub.story.chapters.empty? }
  end

  def set_current_story_id_in_session
    session[:current_story_id] = params[:id] if params[:id]
    session[:current_story_id] = Story.find_by_permalink(params[:story]).id if params[:story]
  end

  def set_current_story_id
    set_current_story_id_in_session
    redirect_to story_path
  end

  def story_chapter
    set_current_story_id_in_session
    redirect_to read_chapter_path(params[:number])
  end

  def chapter
    set_current_story
    @active_user = active_user
    @chapter = @current_story.chapters.find_by_number(params[:number])
    @subscription = active_user.subscriptions.find_by(story: @current_story)
    @subscription.update(last_read_chapter_number: params[:number])
    @call_to_action = CallToActionDecorator.new(@chapter.call_to_action)
    @allow_voting = @subscription.allow_voting_for? @chapter
  end

  def latest
    set_current_story_id_in_session
    set_current_story
    chp_num = @current_story.chapters.published.last.number
    redirect_to read_chapter_path(chp_num)
  end

  private

  def set_current_story
    @current_story || @current_story = Story.find(session[:current_story_id])
  end
end

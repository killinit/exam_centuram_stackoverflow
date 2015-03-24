class QuestionsController < ApplicationController
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :set_question_score, only: [:score_plus, :score_minus]
  before_action :authenticate_user!

  respond_to :html

  def index
    @questions = Question.order("created_at desc").page params[:page]
    respond_with(@questions)
  end

  def show
    respond_with(@question)
  end

  def new
    @question = Question.new
    respond_with(@question)
  end

  def score_plus
    if @question.score.nil?
      new_score = 1 
    else
      new_score = @question.score + 1 
    end
    @question.update_attributes(:score => new_score)
    redirect_to question_path(@question.id)
  end

  def score_minus
    if @question.score.nil? || @question.score == 0
      new_score = 0 
    else
      new_score = @question.score - 1 
    end
    @question.update_attributes(:score => new_score)
    redirect_to question_path(@question.id)
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user_id = current_user.id
    @question.save
    respond_with(@question)
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    @question.destroy
    respond_with(@question)
  end

  private
    def set_question_score
      @question = Question.find(params[:question_id])
    end
    def set_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:content, :score, :user_id, answers_attributes: [:user_id, :content], comments_attributes: [:user_id, :content])
    end
end

class AnswersController < ApplicationController
  before_action :set_answer, only: [:show, :edit, :update, :destroy]
  before_action :set_answer_in_question, only: [:mark_best, :score_plus, :score_minus]
  before_action :authenticate_user!
  
  respond_to :html

  def index
    @answers = Answer.all
    respond_with(@answers)
  end

  def show
    respond_with(@answer)
  end

  def new
    @answer = Answer.new
    respond_with(@answer)
  end

  def edit
  end

  def mark_best
    @question = Question.find(@answer.question_id)
    @question.answers.each do |a|
      a.update_attributes(:best_answer => nil)
    end
    @answer.update_attributes(:best_answer => true)
    redirect_to question_path(@answer.question.id)
  end

  def score_plus
    if @answer.score.nil?
      new_score = 1 
    else
      new_score = @answer.score + 1 
    end
    @answer.update_attributes(:score => new_score)
    redirect_to question_path(@answer.question.id)
  end

  def score_minus
    if @answer.score.nil? || @answer.score == 0
      new_score = 0 
    else
      new_score = @answer.score - 1 
    end
    @answer.update_attributes(:score => new_score)
    redirect_to question_path(@answer.question.id)
  end

  def create
    @answer = Answer.new(answer_params)
    @answer.save
    redirect_to question_path(@answer.question.id)
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def destroy
    @answer.destroy
    respond_with(@answer)
  end

  private
    def set_answer_in_question
      @answer = Answer.find(params[:answer_id])
    end

    def set_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:user_id, :question_id, :content, :score, :best_answer, comments_attributes: [:user_id, :content])
    end
end

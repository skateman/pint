class Session < ActiveRecord::Base
  belongs_to :presentation
  belongs_to :user
  has_many :answers

  def aggregate
    return {} unless current_question
    results = Hash.new(0)
    current_answers.each do |a|
      results[a.number] += 1
    end
    current_question.choices.each_with_index do |choice, index|
      results[choice] = results.delete(index)
    end
    results
  end

  def current_question
    presentation.questions.find_by_slide(slide)
  end

  def current_answers
    answers.where(:question => current_question)
  end

  before_destroy do |record|
    record.answers.delete_all
  end
end

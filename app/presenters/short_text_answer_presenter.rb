class ShortTextAnswerPresenter < BasePresenter
  # A hash of options used in Liquid templates to aid
  # content designers when implementing step logic.
  #
  # @see GetAnswersForSteps
  #
  # @return [Hash]
  def to_param
    {
      response: response,
    }
  end
end

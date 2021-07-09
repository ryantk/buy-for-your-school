class StepPresenter < SimpleDelegator
  # @return [Boolean]
  def question?
    contentful_model == "question"
  end

  # @return [Boolean]
  def statement?
    contentful_model == "statement"
  end

  # @return [String]
  def body_html
    return unless contentful_type == "markdown"

    render_markdown(body)
  end

  # @return [String]
  def help_text_html
    return if help_text.blank?

    render_markdown(help_text)
  end

  # @return [String]
  def status_id
    "#{id}-status"
  end

  # @return [String]
  def response
    @response ||=
      case contentful_type
      when "radios" then RadioAnswerPresenter.new(answer).response
      when "short_text" then ShortTextAnswerPresenter.new(answer).response
      when "long_text" then LongTextAnswerPresenter.new(answer).response
      when "single_date" then SingleDateAnswerPresenter.new(answer).response
      when "checkboxes" then CheckboxesAnswerPresenter.new(answer).concatenated_response
      when "number" then NumberAnswerPresenter.new(answer).response
      when "currency" then CurrencyAnswerPresenter.new(answer).response
      end
  end

private

  # @param text [String]
  #
  # @return [String]
  def render_markdown(text)
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(text).html_safe
  end
end

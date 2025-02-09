# frozen_string_literal: true

module Support
  class BasePresenter < SimpleDelegator
    # @return [String]
    def created_at
      super.strftime(date_format)
    end

    # @return [String]
    def updated_at
      super.strftime(date_format)
    end

  private

    # @return [String]
    def date_format
      "%e %B %Y at %H:%M"
    end
  end
end

# frozen_string_literal: true

class FilterComponent < ViewComponent::Base

  attr_reader :filter, :search_params

  def initialize(filter:, search_params:, checkbox_class:, container_class:, label_class:)
    @filter = filter
    @search_params = search_params || {}
    @checkbox_class = checkbox_class
    @container_class = container_class
    @label_class = label_class
  end

  def call
    safe_join([filter_list_title, filter_list].compact) if filter_list
  end

  private

  def filter_list_title
    content_tag(:h6, title) if title
  end

  def filter_list
    return @filter_list if @filter_list
    return if labels.empty?

    @filter_list = content_tag :ul, class: @container_class do
      safe_join(labels.map { |name, value| filter_list_item(name: name, value: value) })
    end
  end

  def filter_list_item(name:, value:)
    id = filter_list_item_id(name)

    content_tag :li do
      concat check_box_tag(
        "search[#{filter[:scope].to_s}][]",
        value,
        filter_list_item_checked?(value),
        id: id,
        class: @checkbox_class
        )

      concat label_tag(id, name, class: @label_class)
    end
  end

  def filter_list_item_id(name)
    sanitize_to_id("#{filter[:name]}_#{name}")
  end

  def filter_list_item_checked?(value)
    search_params[filter[:scope]]&.include?(value.to_s)
  end

  def title
    filter[:name]
  end

  def labels
    @labels ||= filter[:labels] || filter[:conds].map { |m,c| [m,m] }
  end
end

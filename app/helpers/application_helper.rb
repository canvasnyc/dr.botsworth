module ApplicationHelper
  def edit_button
    content_tag(:span, nil, :class => 'edit button')
  end

  def destroy_button
    content_tag(:span, nil, :class => 'destroy button')
  end

  def new_button
    content_tag(:span, nil, :class => 'new button')
  end
end

# frozen_string_literal: true

class NlaThumbnailComponent < Blacklight::Document::ThumbnailComponent
  def use_thumbnail_tag_behavior?
    !presenter.thumbnail.instance_of?(NlaThumbnailPresenter)
  end
end

# frozen_string_literal: true

class NLAThumbnailComponent < Blacklight::Document::ThumbnailComponent
  def use_thumbnail_tag_behavior?
    !presenter.thumbnail.instance_of?(NLAThumbnailPresenter)
  end
end

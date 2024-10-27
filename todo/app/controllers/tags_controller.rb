class TagsController < ApplicationController
    def render_tag
      tag = params[:tag]
      render partial: 'cards/tags/tag', locals: { tag: tag }
    end
  end
  